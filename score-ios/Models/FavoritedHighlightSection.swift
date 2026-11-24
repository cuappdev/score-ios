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
        let genderPrefix: String
        switch team.gender.lowercased() {
        case "mens", "men", "men's":
            genderPrefix = "Men's"
        case "womens", "women", "women's":
            genderPrefix = "Women's"
        default:
            genderPrefix = team.gender
        }
        return "\(genderPrefix) \(team.sport)"
    }
}
