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

    // MARK: - Singleton
    static let shared = HighlightsViewModel()
    private init() {}

    // MARK: - Computed
    var hasNotFetchedYet: Bool { dataState == .idle }

    // MARK: - Loading
    func loadHighlights() {
        dataState = .loading
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.allHighlights = Highlight.dummyData
            self.filter()
            self.dataState = .success
            self.isLoading = false
        }
    }
    
    func refreshHighlights() {
        loadHighlights()
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

        // --- Main Page Filters (by sport only)
        mainTodayHighlights = filteredBySport.filter {
            guard let date = Date.fullDateFormatter.date(from: $0.publishedAt) else { return false }
            return Date.isWithinPastDays(date, days: 1)
        }

        mainPastThreeDaysHighlights = filteredBySport.filter {
            guard let date = Date.fullDateFormatter.date(from: $0.publishedAt) else { return false }
            return !Date.isWithinPastDays(date, days: 1) && Date.isWithinPastDays(date, days: 3)
        }

        // --- Detailed Page Filters (by sport + search)
        detailedTodayHighlights = filteredBySearch.filter {
            guard let date = Date.fullDateFormatter.date(from: $0.publishedAt) else { return false }
            return Date.isWithinPastDays(date, days: 1)
        }

        detailedPastThreeDaysHighlights = filteredBySearch.filter {
            guard let date = Date.fullDateFormatter.date(from: $0.publishedAt) else { return false }
            return !Date.isWithinPastDays(date, days: 1) && Date.isWithinPastDays(date, days: 3)
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

// MARK: - DataState Extension
extension DataState {
    var isError: Bool {
        if case .error = self { return true }
        return false
    }

    var error: ScoreError? {
        if case .error(let err) = self { return err }
        return nil
    }
}

enum HighlightsScope {
    case main
    case today
    case pastThreeDays
    case all
}
