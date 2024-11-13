//
//  Game.swift
//  score-ios
//
//  Created by Daniel on 9/11/24.
//

import SwiftUI

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



struct Game : GameType {
    var id: UUID = UUID()
    var opponent: String
    var city: String
    var state: String
    var date: Date
    var sport: Sport
    var address: String
    var sex: Sex
    var timeUpdates: [TimeUpdate]
    var gameUpdates: [GameUpdate]
}

struct TimeUpdate {
    var id: UUID = UUID()
    var timestamp: Int
    var isTotal: Bool
    var cornellScore: Int
    var opponentScore: Int
}
// TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)

struct GameUpdate {
    var id: UUID = UUID()
    var timestamp: Int
    var isTotal: Bool
    var cornellScore: Int
    var opponentScore: Int
    var time: Date
    var isCornell: Bool
    var eventParty: EventParty
    var description: String
}
// GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 6, minute: 21), isCornell: true, eventParty: Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")

enum EventParty {
    case Cornell
    case Neither
    case Opponent
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
        Game(opponent: "Penn", city: "Pennsylvania", state: "PA", date: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 10, minute: 0), sport: .Basketball, address: "0 Fake St", sex: .Men, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 6, minute: 21), isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
        Game(opponent: "Harvard", city: "Cambridge", state: "MA", date: Date.dateComponents(year: 2024, month: 5, day: 21, hour: 10, minute: 0), sport: .Football, address: "1 Fake St", sex: .Women, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 6, minute: 21), isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
        Game(opponent: "Princeton", city: "Princeton", state: "NJ", date: Date.dateComponents(year: 2024, month: 5, day: 20, hour: 10, minute: 0), sport: .Basketball, address: "2 Fake St", sex: .Women, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 6, minute: 21), isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
        Game(opponent: "Yale", city: "New Haven", state: "CT", date: Date.dateComponents(year: 2024, month: 5, day: 22, hour: 10, minute: 0), sport: .Soccer, address: "3 Fake St", sex: .Women, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 6, minute: 21), isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
        Game(opponent: "Brown", city: "Providence", state: "RI", date: Date.dateComponents(year: 2024, month: 5, day: 23, hour: 10, minute: 0), sport: .CrossCountry, address: "4 Fake St", sex: .Women, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 6, minute: 21), isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
        Game(opponent: "Dartmouth", city: "Hanover", state: "NH", date: Date.dateComponents(year: 2024, month: 5, day: 24, hour: 10, minute: 0), sport: .IceHockey, address: "5 Fake St", sex: .Women, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 6, minute: 21), isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
        Game(opponent: "Columbia", city: "New York", state: "NY", date: Date.dateComponents(year: 2024, month: 5, day: 25, hour: 10, minute: 0), sport: .Lacrosse, address: "6 Fake St", sex: .Women, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 6, minute: 21), isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
        
        Game(opponent: "Penn", city: "Pennsylvania", state: "PA", date: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 10, minute: 0), sport: .Basketball, address: "0 Fake St", sex: .Men, timeUpdates: [], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 6, minute: 21), isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
        Game(opponent: "Harvard", city: "Cambridge", state: "MA", date: Date.dateComponents(year: 2024, month: 5, day: 21, hour: 10, minute: 0), sport: .Football, address: "1 Fake St", sex: .Men, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 6, minute: 21), isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
        Game(opponent: "Princeton", city: "Princeton", state: "NJ", date: Date.dateComponents(year: 2024, month: 5, day: 20, hour: 10, minute: 0), sport: .Basketball, address: "2 Fake St", sex: .Men, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 6, minute: 21), isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
        Game(opponent: "Yale", city: "New Haven", state: "CT", date: Date.dateComponents(year: 2024, month: 5, day: 22, hour: 10, minute: 0), sport: .Soccer, address: "3 Fake St", sex: .Men, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 6, minute: 21), isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
        Game(opponent: "Brown", city: "Providence", state: "RI", date: Date.dateComponents(year: 2024, month: 5, day: 23, hour: 10, minute: 0), sport: .CrossCountry, address: "4 Fake St", sex: .Men, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 6, minute: 21), isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
        Game(opponent: "Dartmouth", city: "Hanover", state: "NH", date: Date.dateComponents(year: 2024, month: 5, day: 24, hour: 10, minute: 0), sport: .IceHockey, address: "5 Fake St", sex: .Men, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 6, minute: 21), isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")]),
        Game(opponent: "Columbia", city: "New York", state: "NY", date: Date.dateComponents(year: 2024, month: 5, day: 25, hour: 10, minute: 0), sport: .Lacrosse, address: "6 Fake St", sex: .Men, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 6, minute: 21), isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")])
    ]
}

