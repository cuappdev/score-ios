//
//  Game.swift
//  score-ios
//
//  Created by Daniel on 9/11/24.
//

import SwiftUI
import GameAPI

// Note: This is not strictly needed right now, but could be useful for polymorphism in the future if needed
protocol GameType : Identifiable where ID == UUID {
    // On Card and Details
    var opponent: Team { get }
    var city: String { get }
    var state: String { get }
    var date: Date { get }
    var sport: Sport { get }
    var sex: Sex { get }
 
    // TODO add more, maybe longitude and latitude for Transit integration
    var address: String { get }
    
    var timeUpdates: [TimeUpdate] { get }
    var gameUpdates: [GameUpdate] { get }
}

struct Game : GameType, Identifiable {
    var id: UUID = UUID()
    var serverId: String?
    var opponent: Team
    var city: String
    var state: String
    var date: Date
    var sport: Sport
    var address: String
    var sex: Sex
    var timeUpdates: [TimeUpdate] = []
    var gameUpdates: [GameUpdate] = []
    
    enum CodingKeys: String, CodingKey {
        case id, city, state, date, sport, gender, location, opponentId, result, time, scoreBreakdown, boxScore
        case opponent = "team"
    }
    
    init(game: GamesQuery.Data.Game) {
        self.serverId = game.id
        self.city = game.city
        self.state = game.state
        self.date = Date.parseDate(dateString: game.date, timeString: game.time ?? "12:00 p.m.")
        self.sex = game.gender == "Mens" ? .Men : .Women
        self.sport = Sport(normalizedValue: game.sport) ?? .All
        self.opponent = Team(team: game.team!)
        self.address = game.location ?? "N/A"
        self.timeUpdates = parseScoreBreakdown(game.scoreBreakdown)
        self.gameUpdates = parseBoxScore(decodeBoxScoreArray(boxScores: game.boxScore))
    }
    
    init(
            opponent: Team,
            city: String,
            state: String,
            date: Date,
            sport: Sport,
            address: String?,
            sex: Sex,
            timeUpdates: [TimeUpdate],
            gameUpdates: [GameUpdate]
        ) {
            self.opponent = opponent
            self.city = city
            self.state = state
            self.date = date
            self.sport = sport
            self.address = address ?? ""
            self.sex = sex
            self.timeUpdates = timeUpdates
            self.gameUpdates = gameUpdates
        }
    
}

extension Game {
    // parse score breakdown into TimeUpdate
    mutating func parseScoreBreakdown(_ breakdown: [[String?]?]?) -> [TimeUpdate] {
            var updates: [TimeUpdate] = []
            // Parse breakdown and map into `TimeUpdate` array
            // [["1", "2"], ["2", "3"]]
        
        if let breakdown {
            let scoreBreakDown = breakdown
            let corScores = scoreBreakDown[0]
            let oppScores = scoreBreakDown[1]
            var corTotal = 0
            var oppTotal = 0
            if let corScores, let oppScores {
                corScores.indices.forEach({ index in
                    let timeStamp = index + 1
                    if let corScore = corScores[index], let oppScore = oppScores[index] {
                        let corScore = Int(corScore) ?? 0
                        let oppScore = Int(oppScore) ?? 0
                        let timeUpdate = TimeUpdate(timestamp: timeStamp, isTotal: false, cornellScore: corScore, opponentScore: oppScore)
                        corTotal += corScore
                        oppTotal += oppScore
                        updates.append(timeUpdate)
                    }
                    
//                    if (index == corScores.count - 1) {
//                        let total = TimeUpdate(timestamp: index + 1, isTotal: true, cornellScore: corTotal, opponentScore: oppTotal)
//                        updates.append(total)
//                    }
                })
            }
        }
            return updates
        }

    mutating func parseBoxScore(_ boxScore: [BoxScoreItem]) -> [GameUpdate] {
        var updates: [GameUpdate] = []
        // Parse boxScore and map into `GameUpdate` array
        let cornellVariants = ["COR", "CORN", "Cornell", "Cornel", "CU"]
        
        for entry in boxScore {
            let team = entry.team
            let period = entry.period
            let description = entry.description
            let time = entry.time ?? "N/A"
            let corScore = entry.corScore
            let oppScore = entry.oppScore
            
            let timestamp: Int
            if period == "1st" {
                timestamp = 1
            } else if period == "2nd" {
                timestamp = 2
            } else if let parsed = Int(period.dropLast(2)) {
                timestamp = parsed
            } else {
                // Invalid period
                timestamp = -1
            }
            
            let isCornell = cornellVariants.contains(where: {$0.compare(team, options: .caseInsensitive) == .orderedSame})
            let eventParty = EventParty(team: team)
            
            let gameUpdate = GameUpdate(timestamp: timestamp, isTotal: false, cornellScore: corScore, opponentScore: oppScore, time: time, isCornell: isCornell, eventParty: eventParty, description: description)
            
            updates.append(gameUpdate)
        }
        
        return updates
    }
}
