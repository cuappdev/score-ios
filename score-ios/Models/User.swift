//
//  User.swift
//  score-ios
//
//  Created by Duru Alaylı on 9/30/26.
//

import Foundation

struct FavoriteTeam: Codable, Hashable {
    let sport: String
    let gender: String
}

struct User: Codable {
    let id: String
    let email: String?
    let name: String?
    var favoriteTeams: [FavoriteTeam]
    var bookmarkedHighlightIds: [String]

    init(
        id: String,
        email: String?,
        name: String?,
        favoriteTeams: [FavoriteTeam],
        bookmarkedHighlightIds: [String] = []
    ) {
        self.id = id
        self.email = email
        self.name = name
        self.favoriteTeams = favoriteTeams
        self.bookmarkedHighlightIds = bookmarkedHighlightIds
    }

    private enum CodingKeys: String, CodingKey {
        case id, email, name, favoriteTeams, bookmarkedHighlightIds
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        favoriteTeams = try container.decodeIfPresent([FavoriteTeam].self, forKey: .favoriteTeams) ?? []
        bookmarkedHighlightIds = try container.decodeIfPresent([String].self, forKey: .bookmarkedHighlightIds) ?? []
    }
}

extension FavoriteTeam {
    var sex: Sex {
        switch gender.lowercased() {
        case "mens", "men", "men's":
            return .Men
        case "womens", "women", "women's":
            return .Women
        default:
            return .Both
        }
    }
}
