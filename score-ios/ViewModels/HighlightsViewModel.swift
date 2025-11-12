//
//  HighlightsViewModel.swift
//  score-ios
//
//  Created by Zain Bilal on 10/27/25.
//

import Foundation
import SwiftUI
import GameAPI

class HighlightsViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var dataState: DataState = .idle
    @Published var isLoading: Bool = false
    
    @Published var allHighlights: [Highlight] = []
    @Published var mainTodayHighlights: [Highlight] = []
    @Published var mainPastThreeDaysHighlights: [Highlight] = []
    @Published var detailedTodayHighlights: [Highlight] = []
    @Published var detailedPastThreeDaysHighlights: [Highlight] = []
    @Published var allHighlightsSearchResults: [Highlight] = []
    
    @Published var searchQuery: String = ""
    @Published var selectedSport: Sport = .All
    @Published var sportSelectorOffset: CGFloat = 0
    @Published var currentScope: HighlightsScope = .main
    
    // MARK: - Private Properties
    private var privateAllHighlights: [Highlight] = []

    // MARK: - Singleton
    static let shared = HighlightsViewModel()
    private init() {}

    // MARK: - Computed
    var hasNotFetchedYet: Bool { dataState == .idle }

    // MARK: - Loading
    func loadHighlights() {
            dataState = .loading
            isLoading = true
            
            self.allHighlights.removeAll()
            self.mainTodayHighlights.removeAll()
            self.mainPastThreeDaysHighlights.removeAll()
            self.detailedTodayHighlights.removeAll()
            self.detailedPastThreeDaysHighlights.removeAll()
            self.allHighlightsSearchResults.removeAll()
            
            print("calling network manager")
            NetworkManager.shared.fetchArticles() { [weak self] networkArticles, error in
                guard let self = self else { return }
                
                    DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if let error = error {
                        print("Error in fetchArticles: \(error.localizedDescription)")
                        self.handleError(.networkError)
                        return
                    }
                    
                    guard let networkArticles = networkArticles, !networkArticles.isEmpty else {
                        self.handleError(ScoreError.emptyData)
                        return
                    }
                    
                    print("processing higlights")
                    self.processHighlights(networkArticles)
                }
            }
        }
    
    func retryFetch() {
        loadHighlights()
    }
    
    /**
     * Converts network data to local models, sorts, and filters.
     */
    private func processHighlights(_ articleDataArray: [ArticlesQuery.Data.Article]) {
        let localArticles = articleDataArray.map { Article(from: $0) }
        self.privateAllHighlights = localArticles.map { Highlight.article($0) }
        self.allHighlights = self.uniqueHighlights(from: self.privateAllHighlights)
        self.allHighlights.sort(by: { $0.publishedAt > $1.publishedAt })
        self.filter()
        self.dataState = .success
        print(allHighlights)
        print("processed higlights")
    }
    
    /**
     * Function to filter out duplicate highlights by ID.
     */
    private func uniqueHighlights(from highlights: [Highlight]) -> [Highlight] {
        var uniqueHighlights: [Highlight] = []
        var seenIDs: Set<String> = []

        for highlight in highlights {
            if case .article(let article) = highlight {
                if !seenIDs.contains(article.id) {
                    uniqueHighlights.append(highlight)
                    seenIDs.insert(article.id)
                }
            }
            // TODO: Add case for .video when ready
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

        let filteredBySearch: [Highlight]
        if searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            filteredBySearch = filteredBySport
        } else {
            let query = searchQuery.lowercased()
            filteredBySearch = filteredBySport.filter {
                highlightTitle($0).lowercased().contains(query)
            }
        }

        mainTodayHighlights = filteredBySport.filter {
            guard let date = Date.articleDateFormatter.date(from: $0.publishedAt) else { return false }
            return Date.isToday(date)
        }

        mainPastThreeDaysHighlights = filteredBySport.filter {
            guard let date = Date.articleDateFormatter.date(from: $0.publishedAt) else { return false }
            return Date.isWithinPastDays(date, days: 3)
        }

        // --- Detailed Page Filters (by sport + search)
        detailedTodayHighlights = filteredBySearch.filter {
            guard let date = Date.articleDateFormatter.date(from: $0.publishedAt) else { return false }
            return Date.isToday(date)
        }

        detailedPastThreeDaysHighlights = filteredBySearch.filter {
            guard let date = Date.articleDateFormatter.date(from: $0.publishedAt) else { return false }
            return Date.isWithinPastDays(date, days: 3)
        }

        // --- “Search All” Page
        allHighlightsSearchResults = filteredBySearch
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

    func handleError(_ error: ScoreError) {
        DispatchQueue.main.async {
            self.dataState = .error(error: error)
            self.isLoading = false
        }
    }
}

enum HighlightsScope {
    case main
    case today
    case pastThreeDays
    case all
}
