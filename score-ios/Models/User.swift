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
}
