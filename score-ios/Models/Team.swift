//
//  Team.swift
//  score-ios
//
//  Created by Daniel Chuang on 2/23/25.
//
import SwiftUI
import GameAPI

struct Team {
    var id: String
    var color: String
    var image: String
    var name: String

    init(team: GamesQuery.Data.Game.Team) {
        self.id = team.id ?? "N/A"
        self.color = team.color
        self.image = team.image ?? "DEFAULT IMAGE URL" // TODO: make a defualt image url
        self.name = team.name
    }
    
    init(team: GetTeamByIdQuery.Data.Team) {
        self.id = team.id ?? "N/A"
        self.color = team.color
        self.image = team.image ?? "DEFAULT IMAGE URL" // TODO: make a defualt image url
        self.name = team.name
    }
    
    init(id: String, color: String, image: String, name: String) {
        self.id = id
        self.color = color
        self.image = image
        self.name = name
    }
}

extension Team {
    static func defaultTeam() -> Team {
        return Team(id: "N/A", color: "gray", image: "default_image_url", name: "Unknown")
    }
}
