//
//  HighlightsFilter.swift
//  score-ios
//

import Foundation

enum HighlightsFilter: Hashable, Identifiable {
    case all
    case favorited
    case sport(Sport)

    var id: String {
        switch self {
        case .all:
            return "all"
        case .favorited:
            return "favorited"
        case .sport(let sport):
            return sport.rawValue
        }
    }

    var title: String {
        switch self {
        case .all:
            return "All"
        case .favorited:
            return "Favorited"
        case .sport(let sport):
            // Design uses "Hockey" instead of "Ice Hockey" on chips.
            return sport == .IceHockey ? "Hockey" : sport.description
        }
    }

    func matches(_ highlight: Highlight, favoriteTeams: [FavoriteTeam]) -> Bool {
        switch self {
        case .all:
            return true
        case .favorited:
            return favoriteTeams.contains { highlight.matchesFavoriteTeam($0) }
        case .sport(let sport):
            return highlight.sport == sport
        }
    }
}
