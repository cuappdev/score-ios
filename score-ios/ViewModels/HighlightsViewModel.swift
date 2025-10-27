//
//  HighlightsViewModel.swift
//  score-ios
//
//  Created by Zain Bilal on 10/27/25.
//

import Foundation
import SwiftUI

class HighlightsViewModel: ObservableObject {
    // MARK: - Published Properties
    
    /// All highlights (videos and articles)
    @Published var highlights: [Highlight] = []
    
    /// Highlights published today
    @Published var todayHighlights: [Highlight] = []
    
    /// Highlights published in the past 3 days
    @Published var pastThreeDaysHighlights: [Highlight] = []
    
    /// Filtered highlights based on search query
    @Published var filteredHighlights: [Highlight] = []
    
    /// Current search query
    @Published var searchQuery: String = ""
    
    /// Loading state
    @Published var isLoading: Bool = false
    
    /// Current filter state
    @Published var dataState: DataState = .idle
    
    /// Selected sport filter (if any)
    @Published var selectedSport: Sport?
    
    // MARK: - Private Properties
    
    private var allHighlights: [Highlight] = []
    
    // MARK: - Singleton
    
    static let shared = HighlightsViewModel()
    
    // MARK: - Computed Properties
    
    /// Returns whether there are any highlights
    var hasHighlights: Bool {
        return !highlights.isEmpty
    }
    
    /// Returns whether there are today's highlights
    var hasTodayHighlights: Bool {
        return !todayHighlights.isEmpty
    }
    
    /// Returns whether there are past 3 days highlights
    var hasPastThreeDaysHighlights: Bool {
        return !pastThreeDaysHighlights.isEmpty
    }
    
    /// Returns the count of filtered results
    var filteredCount: Int {
        return filteredHighlights.count
    }
    
    /// Returns whether data has been fetched yet
    var hasNotFetchedYet: Bool {
        return dataState == .idle
    }
    
    // MARK: - Initialization
    
    private init(highlights: [Highlight] = []) {
        self.allHighlights = highlights
        self.highlights = highlights
        self.filteredHighlights = highlights
        setupData()
    }
    
    // MARK: - Setup Methods
    
    /// Setup initial data (filter by dates)
    private func setupData() {
        todayHighlights = getTodayHighlights()
        pastThreeDaysHighlights = getPastThreeDaysHighlights()
    }
    
    /// Get highlights published today
    private func getTodayHighlights() -> [Highlight] {
        return highlights.filter {
            if let date = Date.fullDateFormatter.date(from: $0.publishedAt) {
                return Date.isWithinPastDays(date, days: 1)
            }
            return false
        }
    }
    
    /// Get highlights from past 3 days (excluding today)
    private func getPastThreeDaysHighlights() -> [Highlight] {
        return highlights.filter {
            guard let date = Date.fullDateFormatter.date(from: $0.publishedAt) else { return false }
            return !Date.isWithinPastDays(date, days: 1) && Date.isWithinPastDays(date, days: 3)
        }
    }
    
    // MARK: - Data Management
    
    /// Load highlights from dummy data or external source
    func loadHighlights() {
        isLoading = true
        dataState = .loading
        
        // For now, use dummy data
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            self.allHighlights = Highlight.dummyData
            self.highlights = Highlight.dummyData
            self.filteredHighlights = Highlight.dummyData
            self.setupData()
            
            self.isLoading = false
            self.dataState = .success
        }
    }
    
    /// Update highlights data
    func updateHighlights(_ newHighlights: [Highlight]) {
        allHighlights = newHighlights
        highlights = newHighlights
        setupData()
        applyFilters()
    }
    
    /// Refresh highlights
    func refreshHighlights() {
        loadHighlights()
    }
    
    // MARK: - Search Functionality
    
    /// Filter highlights by search query
    func filterBySearch(_ query: String) {
        searchQuery = query
        applyFilters()
    }
    
    /// Clear search
    func clearSearch() {
        searchQuery = ""
        applyFilters()
    }
    
    /// Apply all active filters (search and sport)
    private func applyFilters() {
        var filtered = allHighlights
        
        // Apply search filter
        if !searchQuery.isEmpty {
            let trimmedQuery = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
            filtered = filtered.filter { highlight in
                highlightTitle(highlight).localizedCaseInsensitiveContains(trimmedQuery)
            }
        }
        
        // Apply sport filter (if needed in future)
        if let sport = selectedSport {
            // This would need to be implemented based on how highlights relate to sports
            // filtered = filtered.filter { /* sport logic */ }
        }
        
        filteredHighlights = filtered
    }
    
    /// Get title from highlight
    private func highlightTitle(_ highlight: Highlight) -> String {
        switch highlight {
        case .video(let video):
            return video.title
        case .article(let article):
            return article.title
        }
    }
    
    // MARK: - Filter by Content Type
    
    /// Get all video highlights
    func getVideos() -> [YouTubeVideo] {
        return highlights.compactMap { highlight in
            if case .video(let video) = highlight {
                return video
            }
            return nil
        }
    }
    
    /// Get all article highlights
    func getArticles() -> [Article] {
        return highlights.compactMap { highlight in
            if case .article(let article) = highlight {
                return article
            }
            return nil
        }
    }
    
    /// Filter highlights by content type
    func getHighlightsByType(isVideo: Bool) -> [Highlight] {
        if isVideo {
            return highlights.filter {
                if case .video = $0 {
                    return true
                }
                return false
            }
        } else {
            return highlights.filter {
                if case .article = $0 {
                    return true
                }
                return false
            }
        }
    }
    
    // MARK: - Error Handling
    
    /// Handle error state
    func handleError(_ error: ScoreError) {
        DispatchQueue.main.async { [weak self] in
            self?.dataState = .error(error: error)
            self?.isLoading = false
        }
    }
    
    /// Retry after error
    func retry() {
        loadHighlights()
    }
    
    // MARK: - Helper Methods
    
    /// Get highlight by ID
    func getHighlight(by id: String) -> Highlight? {
        return highlights.first { $0.id == id }
    }
    
    /// Check if highlight is a video
    func isVideo(_ highlight: Highlight) -> Bool {
        if case .video = highlight {
            return true
        }
        return false
    }
    
    /// Check if highlight is an article
    func isArticle(_ highlight: Highlight) -> Bool {
        if case .article = highlight {
            return true
        }
        return false
    }
}

// MARK: - DataState Extension
extension DataState {
    /// Check if state is in error state
    var isError: Bool {
        if case .error = self {
            return true
        }
        return false
    }
    
    /// Get error if in error state
    var error: ScoreError? {
        if case .error(let error) = self {
            return error
        }
        return nil
    }
}
