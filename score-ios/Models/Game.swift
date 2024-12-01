//
//  Game.swift
//  score-ios
//
//  Created by Daniel on 9/11/24.
//

import SwiftUI
import GameAPI

protocol GameType : Identifiable where ID == UUID {
    // On Card and Details
    var opponent: String { get }
    var city: String { get }
    var state: String { get }
    var date: Date { get }
    var sport: Sport { get }
    var sex: Sex { get }
    
    // On Details
    // TODO add more, maybe longitude and latitude for Transit integration? Idk
    var address: String { get }
    
    // TODO: game score details
    var timeUpdates: [TimeUpdate] { get }
    var gameUpdates: [GameUpdate] { get }
}

struct Game : GameType, Identifiable, Decodable {
    var id: UUID = UUID()
    var opponent: String
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
    }
    
    init(game: GamesQuery.Data.Game) {
        self.city = game.city
        self.state = game.state
        self.date = ISO8601DateFormatter().date(from: game.date) ?? Date()
        self.sex = game.gender == "Mens" ? .Men : .Women
        self.sport = Sport(rawValue: game.sport) ?? .All
        self.opponent = "Penn" // TODO: Use opponentId to fetch/display actual name
        self.address = game.location ?? "N/A"
        self.timeUpdates = parseScoreBreakdown(game.scoreBreakdown)
        self.gameUpdates = parseBoxScore(decodeBoxScoreArray(boxScores: game.boxScore))
    }
    
    // decode a Game from backend
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            // Decode and map properties from backend JSON format
            let backendId = try container.decode(String.self, forKey: .id)
            self.id = UUID(uuidString: backendId) ?? UUID()
            self.city = try container.decode(String.self, forKey: .city)
            self.state = try container.decode(String.self, forKey: .state)
            
            // Convert date string to Date type
            let dateString = try container.decode(String.self, forKey: .date)
            self.date = DateFormatter().date(from: dateString) ?? Date()

            let genderString = try container.decode(String.self, forKey: .gender)
            self.sex = genderString == "Mens" ? .Men : .Women

            let sportString = try container.decode(String.self, forKey: .sport)
            self.sport = Sport(rawValue: sportString) ?? .All

            self.opponent = "Opponent Name" // Use opponentId to fetch/display actual name
            
            self.address = try container.decodeIfPresent(String.self, forKey: .location) ?? "N/A"

            // Map boxScore and scoreBreakdown to `timeUpdates` and `gameUpdates`
            // Assuming `boxScore` can be parsed into `GameUpdate`
            // Use similar logic for scoreBreakdown for `TimeUpdate`
        let scoreBreakdown = try container.decode([[String]].self, forKey: .scoreBreakdown)
        let boxScore = try container.decode([BoxScoreItem].self, forKey: .boxScore)
            self.timeUpdates = parseScoreBreakdown(scoreBreakdown) // Parse `scoreBreakdown` here
            self.gameUpdates = parseBoxScore(boxScore) // Parse `boxScore` here
        }
    
    // initializer with provided arguments
    init(
            opponent: String,
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
            return updates
        }

    mutating func parseBoxScore(_ boxScore: [BoxScoreItem]) -> [GameUpdate] {
        var updates: [GameUpdate] = []
        // Parse boxScore and map into `GameUpdate` array
        
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
            
            let isCornell = team == "COR"
            let eventParty = EventParty(team: team)
            
            let gameUpdate = GameUpdate(timestamp: timestamp, isTotal: false, cornellScore: corScore, opponentScore: oppScore, time: time, isCornell: isCornell, eventParty: eventParty, description: description)
            
            updates.append(gameUpdate)
        }
        
        return updates
    }
}

struct TimeUpdate {
    var id: UUID = UUID()
    var timestamp: Int
    var isTotal: Bool
    var cornellScore: Int
    var opponentScore: Int
}

// for decoding a boxScore from backend
struct BoxScoreItem: Decodable {
    let team: String
    let period: String
    let time: String?
    let description: String
    let scorer: String?
    let assist: String?
    let scoreBy: String?
    let corScore: Int
    let oppScore: Int
    
    init(item: GamesQuery.Data.Game.BoxScore?) {
        if let item = item {
            self.team = item.team ?? ""
            self.period = item.period ?? ""
            self.time = item.time ?? ""
            self.description = item.description ?? "N/A"
            self.scorer = item.scorer ?? ""
            self.assist = item.assist ?? ""
            self.scoreBy = item.scoreBy ?? ""
            self.corScore = item.corScore ?? 0
            self.oppScore = item.oppScore ?? 0
        } else {
            self.team = ""
            self.period = ""
            self.time = ""
            self.description = "N/A"
            self.scorer = ""
            self.assist = ""
            self.scoreBy = ""
            self.corScore = 0
            self.oppScore = 0
        }
    }
}

func decodeBoxScoreArray(boxScores: [GamesQuery.Data.Game.BoxScore?]?) -> [BoxScoreItem] {
    var result: [BoxScoreItem] = []
    if let boxScores = boxScores {
        for score in boxScores {
            if score != nil {
                result.append(BoxScoreItem(item: score))
            }
        }
    }
    return result
}

struct GameUpdate {
    var id: UUID = UUID() // discard
    var timestamp: Int // period
    var isTotal: Bool // discard
    var cornellScore: Int // corScore
    var opponentScore: Int // oppScore
    var time: String // time
    var isCornell: Bool //
    var eventParty: EventParty // team
    var description: String // description
}

enum EventParty {
    case Cornell
    case Neither
    case Opponent
    
    init(team: String?) {
        switch team {
            case "COR":
                self = .Cornell
            default:
                self = .Opponent
        }
    }
}

// Enums for various types
enum Opponent : String {
    case Penn
    case Princeton
    case Harvard
    case Yale
    case Brown
    case Dartmouth
    case Columbia
}

enum Sport : String, Identifiable, CaseIterable, CustomStringConvertible {
    // https://health.cornell.edu/services/sports-medicine/sports-clearance/ncaa-teams
    var id: Self { self }
    
    case All
    
    // Both
    case Basketball
    case CrossCountry
    case IceHockey
    case Lacrosse
    case Soccer
    case Squash
    case SwimmingDiving
    case Tennis
    case TrackField
    
    // Women
    case Fencing
    case FieldHockey
    case Gymnastics
    case Rowing
    case Sailing
    case Softball
    case Volleyball
    
    // Men
    case Baseball
    case Football
    case Golf
    case RowingHeavyweight
    case RowingLightweight
    case SprintFootball
    case Wrestling
    
    // Make a to string function
    var description: String {
        switch self {
        case .All:
            return "All"
        case .Basketball:
            return "Basketball"
        case .CrossCountry:
            return "Cross Country"
        case .IceHockey:
            return "Ice Hockey"
        case .Lacrosse:
            return "Lacrosse"
        case .Soccer:
            return "Soccer"
        case .Squash:
            return "Squash"
        case .SwimmingDiving:
            return "Swimming and Diving"
        case .Tennis:
            return "Tennis"
        case .TrackField:
            return "Track and Field"
        case .Fencing:
            return "Fencing"
        case .FieldHockey:
            return "Field Hockey"
        case .Gymnastics:
            return "Gymnastics"
        case .Rowing:
            return "Rowing"
        case .Sailing:
            return "Sailing"
        case .Softball:
            return "Softball"
        case .Volleyball:
            return "Volleyball"
        case .Baseball:
            return "Baseball"
        case .Football:
            return "Football"
        case .Golf:
            return "Golf"
        case .RowingHeavyweight:
            return "HW Rowing"
        case .RowingLightweight:
            return "LW Rowing"
        case .SprintFootball:
            return "Sprint Football"
        case .Wrestling:
            return "Wrestling"
        }
    }
}

enum Sex : Identifiable, CaseIterable, CustomStringConvertible {
    var id: Self { self }
    
    case Both
    case Men
    case Women
    
    var description: String {
        switch self {
        case .Both:
            return "All"
        case .Men:
            return "Men's"
        case .Women:
            return "Women's"
        }
        
    }
    // This is strictly for filtering purposes, all datum should have one of Men or Women
    static func index(of sex: Sex) -> Int? {
        return allCases.firstIndex(of: sex)
    }
}

// TEMP Dummy data
extension Game {
    static let dummyData: [Game] = [
        Game(opponent: "Penn", city: "Pennsylvania", state: "PA", date: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 10, minute: 0), sport: .Basketball, address: "0 Fake St", sex: .Men, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: "05/19/2024", isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
        Game(opponent: "Harvard", city: "Cambridge", state: "MA", date: Date.dateComponents(year: 2024, month: 5, day: 21, hour: 10, minute: 0), sport: .Football, address: "1 Fake St", sex: .Women, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: "05/19/2024", isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
        Game(opponent: "Princeton", city: "Princeton", state: "NJ", date: Date.dateComponents(year: 2024, month: 5, day: 20, hour: 10, minute: 0), sport: .Basketball, address: "2 Fake St", sex: .Women, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: "05/19/2024", isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
        Game(opponent: "Yale", city: "New Haven", state: "CT", date: Date.dateComponents(year: 2024, month: 5, day: 22, hour: 10, minute: 0), sport: .Soccer, address: "3 Fake St", sex: .Women, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: "05/19/2024", isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
        Game(opponent: "Brown", city: "Providence", state: "RI", date: Date.dateComponents(year: 2024, month: 5, day: 23, hour: 10, minute: 0), sport: .CrossCountry, address: "4 Fake St", sex: .Women, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: "05/19/2024", isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
        Game(opponent: "Dartmouth", city: "Hanover", state: "NH", date: Date.dateComponents(year: 2024, month: 5, day: 24, hour: 10, minute: 0), sport: .IceHockey, address: "5 Fake St", sex: .Women, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: "05/19/2024", isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
        Game(opponent: "Columbia", city: "New York", state: "NY", date: Date.dateComponents(year: 2024, month: 5, day: 25, hour: 10, minute: 0), sport: .Lacrosse, address: "6 Fake St", sex: .Women, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: "05/19/2024", isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
        
        Game(opponent: "Penn", city: "Pennsylvania", state: "PA", date: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 10, minute: 0), sport: .Basketball, address: "0 Fake St", sex: .Men, timeUpdates: [], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: "05/19/2024", isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
        Game(opponent: "Harvard", city: "Cambridge", state: "MA", date: Date.dateComponents(year: 2024, month: 5, day: 21, hour: 10, minute: 0), sport: .Football, address: "1 Fake St", sex: .Men, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: "05/19/2024", isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
        Game(opponent: "Princeton", city: "Princeton", state: "NJ", date: Date.dateComponents(year: 2024, month: 5, day: 20, hour: 10, minute: 0), sport: .Basketball, address: "2 Fake St", sex: .Men, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: "05/19/2024", isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
        Game(opponent: "Yale", city: "New Haven", state: "CT", date: Date.dateComponents(year: 2024, month: 5, day: 22, hour: 10, minute: 0), sport: .Soccer, address: "3 Fake St", sex: .Men, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: "05/19/2024", isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
        Game(opponent: "Brown", city: "Providence", state: "RI", date: Date.dateComponents(year: 2024, month: 5, day: 23, hour: 10, minute: 0), sport: .CrossCountry, address: "4 Fake St", sex: .Men, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: "05/19/2024", isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
        Game(opponent: "Dartmouth", city: "Hanover", state: "NH", date: Date.dateComponents(year: 2024, month: 5, day: 24, hour: 10, minute: 0), sport: .IceHockey, address: "5 Fake St", sex: .Men, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: "05/19/2024", isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
        Game(opponent: "Columbia", city: "New York", state: "NY", date: Date.dateComponents(year: 2024, month: 5, day: 25, hour: 10, minute: 0), sport: .Lacrosse, address: "6 Fake St", sex: .Men, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: "05/19/2024", isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")])
    ]
//    static let dummyData: [Game] = [
//        Game(opponent: "Penn", city: "Pennsylvania", state: "PA", date: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 10, minute: 0), sport: .Basketball, address: "0 Fake St", sex: .Men, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 6, minute: 21), isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
//        Game(opponent: "Harvard", city: "Cambridge", state: "MA", date: Date.dateComponents(year: 2024, month: 5, day: 21, hour: 10, minute: 0), sport: .Football, address: "1 Fake St", sex: .Women, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 6, minute: 21), isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
//        Game(opponent: "Princeton", city: "Princeton", state: "NJ", date: Date.dateComponents(year: 2024, month: 5, day: 20, hour: 10, minute: 0), sport: .Basketball, address: "2 Fake St", sex: .Women, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 6, minute: 21), isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
//        Game(opponent: "Yale", city: "New Haven", state: "CT", date: Date.dateComponents(year: 2024, month: 5, day: 22, hour: 10, minute: 0), sport: .Soccer, address: "3 Fake St", sex: .Women, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 6, minute: 21), isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
//        Game(opponent: "Brown", city: "Providence", state: "RI", date: Date.dateComponents(year: 2024, month: 5, day: 23, hour: 10, minute: 0), sport: .CrossCountry, address: "4 Fake St", sex: .Women, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 6, minute: 21), isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
//        Game(opponent: "Dartmouth", city: "Hanover", state: "NH", date: Date.dateComponents(year: 2024, month: 5, day: 24, hour: 10, minute: 0), sport: .IceHockey, address: "5 Fake St", sex: .Women, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 6, minute: 21), isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
//        Game(opponent: "Columbia", city: "New York", state: "NY", date: Date.dateComponents(year: 2024, month: 5, day: 25, hour: 10, minute: 0), sport: .Lacrosse, address: "6 Fake St", sex: .Women, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 6, minute: 21), isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
//        
//        Game(opponent: "Penn", city: "Pennsylvania", state: "PA", date: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 10, minute: 0), sport: .Basketball, address: "0 Fake St", sex: .Men, timeUpdates: [], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 6, minute: 21), isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
//        Game(opponent: "Harvard", city: "Cambridge", state: "MA", date: Date.dateComponents(year: 2024, month: 5, day: 21, hour: 10, minute: 0), sport: .Football, address: "1 Fake St", sex: .Men, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 6, minute: 21), isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
//        Game(opponent: "Princeton", city: "Princeton", state: "NJ", date: Date.dateComponents(year: 2024, month: 5, day: 20, hour: 10, minute: 0), sport: .Basketball, address: "2 Fake St", sex: .Men, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 6, minute: 21), isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
//        Game(opponent: "Yale", city: "New Haven", state: "CT", date: Date.dateComponents(year: 2024, month: 5, day: 22, hour: 10, minute: 0), sport: .Soccer, address: "3 Fake St", sex: .Men, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 6, minute: 21), isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
//        Game(opponent: "Brown", city: "Providence", state: "RI", date: Date.dateComponents(year: 2024, month: 5, day: 23, hour: 10, minute: 0), sport: .CrossCountry, address: "4 Fake St", sex: .Men, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 6, minute: 21), isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
//        Game(opponent: "Dartmouth", city: "Hanover", state: "NH", date: Date.dateComponents(year: 2024, month: 5, day: 24, hour: 10, minute: 0), sport: .IceHockey, address: "5 Fake St", sex: .Men, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 6, minute: 21), isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
//        Game(opponent: "Columbia", city: "New York", state: "NY", date: Date.dateComponents(year: 2024, month: 5, day: 25, hour: 10, minute: 0), sport: .Lacrosse, address: "6 Fake St", sex: .Men, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 6, minute: 21), isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")])
//    ]
}

