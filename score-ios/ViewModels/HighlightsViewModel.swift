//
//  HighlightsViewModel.swift
//  score-ios
//
//  Created by Zain Bilal on 10/27/25.
//

import Combine
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
    @Published var favoritedSections: [FavoritedHighlightSection] = []
    @Published var bookmarkedHighlights: [Highlight] = []

    @Published var searchQuery: String = ""
    @Published var selectedFilter: HighlightsFilter = .all

    @Published var showSignInToSave = false
    @Published private(set) var toastMessage: String?
    @Published private(set) var toastIsError = false
    @Published private(set) var bookmarkedIds: Set<String> = []
    @Published private(set) var pendingBookmarkIds: Set<String> = []

    // MARK: - Private Properties
    /// In-flight highlights load. Owned by the view model so leaving the screen
    /// does not cancel it; a newer load cancels this one.
    private var loadTask: Task<Void, Never>?
    private var toastDismissTask: Task<Void, Never>?
    private var bookmarkTasks: [String: Task<Void, Never>] = [:]
    private var pendingBookmarkHighlight: Highlight?
    private var offFeedBookmarks: [Highlight] = []
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Singleton
    static let shared = HighlightsViewModel()
    private init() {
        syncBookmarksFromAuth()
        AuthManager.shared.$currentUser
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] _ in
                self?.syncBookmarksFromAuth()
            }
            .store(in: &cancellables)
    }

    // MARK: - Computed
    var hasNotFetchedYet: Bool { dataState == .idle }

    var hasFavoriteTeams: Bool {
        !(AuthManager.shared.currentUser?.favoriteTeams.isEmpty ?? true)
    }

    /// Kept for call sites that still read a sport selection.
    var selectedSport: Sport {
        get {
            if case .sport(let sport) = selectedFilter { return sport }
            return .All
        }
        set {
            selectedFilter = newValue == .All ? .all : .sport(newValue)
            filter()
        }
    }

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
            await refreshBookmarks(forceNetwork: forceNetwork)
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

    private func processHighlights(
        _ articleDataArray: [ArticlesQuery.Data.Article],
        _ youTubeVideoDataArray: [YoutubeVideosQuery.Data.YoutubeVideo]
    ) {
        let localArticles = articleDataArray.map { Article(from: $0) }
        let localYouTubeVideos = youTubeVideoDataArray.map { YouTubeVideo(from: $0) }
        let combined = localArticles.map { Highlight.article($0) }
            + localYouTubeVideos.map { Highlight.video($0) }

        allHighlights = uniqueHighlights(from: combined)
        allHighlights.sort(by: { $0.publishedAt > $1.publishedAt })
        filter()
        dataState = .success
    }

    private func uniqueHighlights(from highlights: [Highlight]) -> [Highlight] {
        var seenIDs = Set<String>()
        return highlights.filter { seenIDs.insert($0.id).inserted }
    }

    // MARK: - Filtering
    func filter() {
        if selectedFilter == .favorited && !hasFavoriteTeams {
            selectedFilter = .all
        }

        let filteredByFilter = highlightsMatching(selectedFilter)
        let query = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        let filteredBySearch: [Highlight]
        if query.isEmpty {
            filteredBySearch = filteredByFilter
        } else {
            let lowered = query.lowercased()
            filteredBySearch = filteredByFilter.filter {
                $0.title.lowercased().contains(lowered)
            }
        }

        let now = Date()
        let mainBuckets = bucket(filteredByFilter, now: now)
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

        allHighlightsSearchResults = filteredBySearch
        favoritedSections = buildFavoritedSections(from: allHighlights)
        rebuildBookmarkedHighlightsList()
    }

    private func highlightsMatching(_ filter: HighlightsFilter) -> [Highlight] {
        let teams = AuthManager.shared.currentUser?.favoriteTeams ?? []
        return allHighlights.filter { filter.matches($0, favoriteTeams: teams) }
    }

    private func buildFavoritedSections(from highlights: [Highlight]) -> [FavoritedHighlightSection] {
        let teams = AuthManager.shared.currentUser?.favoriteTeams ?? []
        var seen = Set<String>()
        let sections = teams.compactMap { team -> FavoritedHighlightSection? in
            let section = FavoritedHighlightSection(
                team: team,
                highlights: highlights.filter { $0.matchesFavoriteTeam(team) }
            )
            return seen.insert(section.id).inserted ? section : nil
        }

        return sections.sorted { lhs, rhs in
            switch (lhs.highlights.isEmpty, rhs.highlights.isEmpty) {
            case (false, true):
                return true
            case (true, false):
                return false
            default:
                return lhs.title.localizedCaseInsensitiveCompare(rhs.title) == .orderedAscending
            }
        }
    }

    private func rebuildBookmarkedHighlightsList() {
        let feedMatches = allHighlights.filter {
            $0.isBookmarkable && bookmarkedIds.contains($0.id)
        }
        let feedIds = Set(feedMatches.map(\.id))
        let offFeedMatches = offFeedBookmarks.filter { bookmark in
            bookmark.isBookmarkable
                && bookmarkedIds.contains(bookmark.id)
                && !feedIds.contains(bookmark.id)
        }
        bookmarkedHighlights = (feedMatches + offFeedMatches)
            .sorted { $0.publishedAt > $1.publishedAt }
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

    // MARK: - Search & Filter
    func filterBySearch(_ query: String) {
        searchQuery = query
        filter()
    }

    func clearSearch() {
        searchQuery = ""
        filter()
    }

    func selectFilter(_ newFilter: HighlightsFilter) {
        selectedFilter = newFilter
        filter()
    }

    // MARK: - Bookmarks
    var filteredBookmarkedHighlights: [Highlight] {
        applyingSelectedFilter(to: bookmarkedHighlights)
    }

    func applyingSelectedFilter(to highlights: [Highlight]) -> [Highlight] {
        let teams = AuthManager.shared.currentUser?.favoriteTeams ?? []
        return highlights.filter { selectedFilter.matches($0, favoriteTeams: teams) }
    }

    func isBookmarked(_ highlight: Highlight) -> Bool {
        bookmarkedIds.contains(highlight.id)
    }

    func isBookmarkPending(_ highlight: Highlight) -> Bool {
        pendingBookmarkIds.contains(highlight.id)
    }

    func toggleBookmark(for highlight: Highlight) {
        guard highlight.isBookmarkable else { return }

        guard AuthManager.shared.isSignedIn else {
            pendingBookmarkHighlight = highlight
            showSignInToSave = true
            return
        }

        let id = highlight.id
        guard !pendingBookmarkIds.contains(id) else { return }

        pendingBookmarkIds.insert(id)
        bookmarkTasks[id] = Task { [weak self] in
            await self?.performBookmarkToggle(id: id)
        }
    }

    func dismissSignInToSave() {
        showSignInToSave = false
        pendingBookmarkHighlight = nil
    }

    func handleSignInSuccess() {
        showSignInToSave = false
        let pending = pendingBookmarkHighlight
        pendingBookmarkHighlight = nil
        Task { [weak self] in
            guard let self else { return }
            await self.refreshBookmarks(forceNetwork: true)
            if let pending, !self.isBookmarked(pending) {
                self.toggleBookmark(for: pending)
            }
        }
    }

    func syncBookmarksFromAuth() {
        guard AuthManager.shared.isSignedIn else {
            bookmarkedIds = []
            offFeedBookmarks = []
            bookmarkedHighlights = []
            favoritedSections = []
            if selectedFilter == .favorited {
                selectedFilter = .all
            }
            filter()
            return
        }
        bookmarkedIds = Set(AuthManager.shared.currentUser?.bookmarkedHighlightIds ?? [])
        filter()
    }

    /// Pulls remote bookmarked videos (including ones older than the feed).
    func refreshBookmarks(forceNetwork: Bool = false) async {
        guard AuthManager.shared.isSignedIn else {
            bookmarkedIds = []
            offFeedBookmarks = []
            bookmarkedHighlights = []
            return
        }

        syncBookmarksFromAuth()

        do {
            let remote = try await NetworkManager.shared.fetchMyBookmarkedHighlights(forceNetwork: forceNetwork)
            if Task.isCancelled { return }
            let videos = remote.map { YouTubeVideo(from: $0) }.map { Highlight.video($0) }
            let remoteVideoIds = Set(videos.map(\.id))
            // Backend bookmarks are video-only; drop any leftover article IDs.
            bookmarkedIds = remoteVideoIds
            AuthManager.shared.updateBookmarkedHighlightIds(Array(bookmarkedIds))

            let fromFeed = allHighlights.filter { bookmarkedIds.contains($0.id) }
            let fromFeedIds = Set(fromFeed.map(\.id))
            offFeedBookmarks = videos.filter { !fromFeedIds.contains($0.id) }
            rebuildBookmarkedHighlightsList()
        } catch {
            // Keep locally cached bookmark IDs if the remote refresh fails.
        }
    }

    private func performBookmarkToggle(id: String) async {
        defer {
            bookmarkTasks.removeValue(forKey: id)
            pendingBookmarkIds.remove(id)
        }

        let wasBookmarked = bookmarkedIds.contains(id)
        if wasBookmarked {
            bookmarkedIds.remove(id)
        } else {
            bookmarkedIds.insert(id)
            presentToast("Highlight saved! Manage in Profile.")
        }
        AuthManager.shared.updateBookmarkedHighlightIds(Array(bookmarkedIds))
        filter()

        do {
            if wasBookmarked {
                try await NetworkManager.shared.removeBookmarkedHighlight(highlightId: id)
            } else {
                try await NetworkManager.shared.addBookmarkedHighlight(highlightId: id)
            }
        } catch is CancellationError {
            return
        } catch {
            guard !Task.isCancelled else { return }
            if wasBookmarked {
                bookmarkedIds.insert(id)
            } else {
                bookmarkedIds.remove(id)
            }
            AuthManager.shared.updateBookmarkedHighlightIds(Array(bookmarkedIds))
            filter()
            presentToast("Couldn't update bookmark. Try again.", isError: true)
        }
    }

    private func presentToast(_ message: String, isError: Bool = false) {
        toastDismissTask?.cancel()
        toastIsError = isError
        toastMessage = message
        toastDismissTask = Task {
            try? await Task.sleep(for: .seconds(2.2))
            guard !Task.isCancelled else { return }
            toastMessage = nil
            toastIsError = false
        }
    }
}
