//
//  FavoritedHighlightSection.swift
//  score-ios
//

import Foundation

struct FavoritedHighlightSection: Identifiable, Equatable {
    let team: FavoriteTeam
    let highlights: [Highlight]

    var id: String { "\(team.gender)-\(team.sport)" }

    var title: String {
        "\(team.sex.description) \(team.sport)"
    }
}
