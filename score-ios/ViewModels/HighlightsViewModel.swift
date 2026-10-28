//
//  HighlightsViewModel.swift
//  score-ios
//
//  Created by Zain Bilal on 10/27/25.
//

import Foundation
import SwiftUI
import GameAPI

@MainActor
class HighlightsViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var dataState: DataState = .idle
    
    @Published var allHighlights: [Highlight] = []
    @Published var mainLastWeekHighlights: [Highlight] = []
    @Published var mainRecentHighlights: [Highlight] = []
    @Published var detailedLastWeekHighlights: [Highlight] = []
    @Published var detailedRecentHighlights: [Highlight] = []
    @Published var allHighlightsSearchResults: [Highlight] = []
    
    @Published var searchQuery: String = ""
    @Published var selectedSport: Sport = .All
    @Published var sportSelectorOffset: CGFloat = 0
    @Published var currentScope: HighlightsScope = .main
    
    // MARK: - Private Properties
    private var privateAllHighlights: [Highlight] = []
    /// In-flight highlights load. Owned by the view model so leaving the screen
    /// does not cancel it; a newer load cancels this one.
    private var loadTask: Task<Void, Never>?

    // MARK: - Singleton
    static let shared = HighlightsViewModel()
    private init() {}

    // MARK: - Computed
    var hasNotFetchedYet: Bool { dataState == .idle }

    // MARK: - Loading
    /// Returns when this fetch finishes. Work runs in `loadTask`, so SwiftUI
    /// cancelling the caller (tab switch) does not abort it. A newer call cancels the previous one.
    func loadHighlights(forceNetwork: Bool = false) async {
        loadTask?.cancel()

        let task = Task { [weak self] in
            guard let self else { return }
            await self.fetchHighlights(forceNetwork: forceNetwork)
        }
        loadTask = task
        await task.value
    }

    private func fetchHighlights(forceNetwork: Bool) async {
        // Soft refresh: if we already showed content, keep it on screen until a successful replace.
        let preserveExistingUI = (dataState == .success)
        if !preserveExistingUI {
            dataState = .loading
        }

        do {
            async let articles = NetworkManager.shared.fetchArticles(forceNetwork: forceNetwork)
            async let videos = NetworkManager.shared.fetchYoutubeVideos(forceNetwork: forceNetwork)
            let (articleData, videoData) = try await (articles, videos)
            if Task.isCancelled { return }
            if articleData.isEmpty && videoData.isEmpty {
                if preserveExistingUI {
                    dataState = .success
                } else {
                    dataState = .error(error: .emptyData)
                }
                return
            }
            processHighlights(articleData, videoData)
        } catch is CancellationError {
            // Superseded by a newer load — leave dataState alone.
        } catch {
            if Task.isCancelled { return }
            if preserveExistingUI {
                dataState = .success
            } else {
                dataState = .error(error: .networkError)
            }
        }
    }
    
    /**
     * Converts network data to local models, sorts, and filters.
     */
    private func processHighlights(_ articleDataArray: [ArticlesQuery.Data.Article], _ youTubeVideoDataArray: [YoutubeVideosQuery.Data.YoutubeVideo]) {
        let localArticles = articleDataArray.map { Article(from: $0) }
        let localYouTubeVideos = youTubeVideoDataArray.map {YouTubeVideo(from: $0)}

        self.privateAllHighlights = localArticles.map { Highlight.article($0) } + localYouTubeVideos.map { Highlight.video($0) }
        self.allHighlights = self.uniqueHighlights(from: self.privateAllHighlights)
        self.allHighlights.sort(by: { $0.publishedAt > $1.publishedAt })
        self.filter()

        self.dataState = .success
    }
    
    /**
     * Function to filter out duplicate highlights by ID.
     */
    private func uniqueHighlights(from highlights: [Highlight]) -> [Highlight] {
        var uniqueHighlights: [Highlight] = []
        var seenArticleIDs: Set<String> = []
        var seenVideoIDs: Set<String> = []

        for highlight in highlights {
            if case .article(let article) = highlight {
                if !seenArticleIDs.contains(article.id) {
                    uniqueHighlights.append(highlight)
                    seenArticleIDs.insert(article.id)
                }
            }
            if case .video(let video) = highlight {
                if !seenVideoIDs.contains(video.id) {
                    uniqueHighlights.append(highlight)
                    seenVideoIDs.insert(video.id)
                }
            }
        }
        return uniqueHighlights
    }

    // MARK: - Filtering
    func filter() {
        let filteredBySport: [Highlight]
        if selectedSport == .All {
            filteredBySport = allHighlights
        } else {
            filteredBySport = allHighlights.filter { $0.sport == selectedSport }
        }

        let query = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        let filteredBySearch: [Highlight]
        if query.isEmpty {
            filteredBySearch = filteredBySport
        } else {
            let lowered = query.lowercased()
            filteredBySearch = filteredBySport.filter {
                highlightTitle($0).lowercased().contains(lowered)
            }
        }

        let now = Date()
        let mainBuckets = bucket(filteredBySport, now: now)
        mainLastWeekHighlights = mainBuckets.lastWeek
        mainRecentHighlights = mainBuckets.recent

        if query.isEmpty {
            detailedLastWeekHighlights = mainBuckets.lastWeek
            detailedRecentHighlights = mainBuckets.recent
        } else {
            let detailedBuckets = bucket(filteredBySearch, now: now)
            detailedLastWeekHighlights = detailedBuckets.lastWeek
            detailedRecentHighlights = detailedBuckets.recent
        }

        // --- “Search All” Page
        allHighlightsSearchResults = filteredBySearch
    }

    /// One parse per highlight. Last week wins, so Recent is the rest of the 30-day window.
    private func bucket(_ highlights: [Highlight], now: Date) -> (lastWeek: [Highlight], recent: [Highlight]) {
        var lastWeek: [Highlight] = []
        var recent: [Highlight] = []
        for highlight in highlights {
            guard let date = Date.highlightDateFormatter.date(from: highlight.publishedAt) else { continue }
            if Date.isInLastWeek(date, now: now) {
                lastWeek.append(highlight)
            } else if Date.isInRecentMonth(date, now: now) {
                recent.append(highlight)
            }
        }
        return (lastWeek, recent)
    }

    // MARK: - Search & Sport
    func filterBySearch(_ query: String) {
        searchQuery = query
        filter()
    }

    func clearSearch() {
        searchQuery = ""
        filter()
    }

    func selectSport(_ sport: Sport) {
        selectedSport = sport
        filter()
    }

    // MARK: - Helpers
    private func highlightTitle(_ highlight: Highlight) -> String {
        switch highlight {
        case .video(let video): return video.title
        case .article(let article): return article.title
        }
    }
}

enum HighlightsScope {
    case main
    case lastWeek
    case recent
    case all
}
