//
//  Game.swift
//  score-ios
//
//  Created by Daniel on 9/11/24.
//

import SwiftUI

protocol GameType : Identifiable where ID == UUID {
    // On Card and Details
    var opponent: Opponent { get }
    var city: String { get }
    var state: String { get }
    var date: Date { get }
    var sport: Sport { get }
    var sex: Sex { get }
    
    // On Details
    // TODO add more, maybe longitude and latitude for Transit integration? Idk
    var address: String { get }
}

struct Game : GameType {
    var id: UUID = UUID()
    var opponent: Opponent
    var city: String
    var state: String
    var date: Date
    var sport: Sport
    var address: String
    var sex: Sex
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
    case Polo
    case Soccer
    case Squash
    case SwimmingDiving
    case Tennis
    case TrackField
    
    // Women
    case Equestrian
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
        case .Polo:
            return "Polo"
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
        case .Equestrian:
            return "Equestrian"
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
            return "Rowing Heavyweight"
        case .RowingLightweight:
            return "Rowing Lightweight"
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
            return "Both"
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
        Game(opponent: .Penn, city: "Pennsylvania", state: "PA", date: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 10, minute: 0), sport: .Basketball, address: "0 Fake St", sex: .Men),
        Game(opponent: .Harvard, city: "Cambridge", state: "MA", date: Date.dateComponents(year: 2024, month: 5, day: 21, hour: 10, minute: 0), sport: .Football, address: "1 Fake St", sex: .Women),
        Game(opponent: .Princeton, city: "Princeton", state: "NJ", date: Date.dateComponents(year: 2024, month: 5, day: 20, hour: 10, minute: 0), sport: .Basketball, address: "2 Fake St", sex: .Women),
        Game(opponent: .Yale, city: "New Haven", state: "CT", date: Date.dateComponents(year: 2024, month: 5, day: 22, hour: 10, minute: 0), sport: .Soccer, address: "3 Fake St", sex: .Women),
        Game(opponent: .Brown, city: "Providence", state: "RI", date: Date.dateComponents(year: 2024, month: 5, day: 23, hour: 10, minute: 0), sport: .CrossCountry, address: "4 Fake St", sex: .Women),
        Game(opponent: .Dartmouth, city: "Hanover", state: "NH", date: Date.dateComponents(year: 2024, month: 5, day: 24, hour: 10, minute: 0), sport: .IceHockey, address: "5 Fake St", sex: .Women),
        Game(opponent: .Columbia, city: "New York", state: "NY", date: Date.dateComponents(year: 2024, month: 5, day: 25, hour: 10, minute: 0), sport: .Lacrosse, address: "6 Fake St", sex: .Women),
        
        Game(opponent: .Penn, city: "Pennsylvania", state: "PA", date: Date.dateComponents(year: 2024, month: 5, day: 19, hour: 10, minute: 0), sport: .Basketball, address: "0 Fake St", sex: .Men),
        Game(opponent: .Harvard, city: "Cambridge", state: "MA", date: Date.dateComponents(year: 2024, month: 5, day: 21, hour: 10, minute: 0), sport: .Football, address: "1 Fake St", sex: .Men),
        Game(opponent: .Princeton, city: "Princeton", state: "NJ", date: Date.dateComponents(year: 2024, month: 5, day: 20, hour: 10, minute: 0), sport: .Basketball, address: "2 Fake St", sex: .Men),
        Game(opponent: .Yale, city: "New Haven", state: "CT", date: Date.dateComponents(year: 2024, month: 5, day: 22, hour: 10, minute: 0), sport: .Soccer, address: "3 Fake St", sex: .Men),
        Game(opponent: .Brown, city: "Providence", state: "RI", date: Date.dateComponents(year: 2024, month: 5, day: 23, hour: 10, minute: 0), sport: .CrossCountry, address: "4 Fake St", sex: .Men),
        Game(opponent: .Dartmouth, city: "Hanover", state: "NH", date: Date.dateComponents(year: 2024, month: 5, day: 24, hour: 10, minute: 0), sport: .IceHockey, address: "5 Fake St", sex: .Men),
        Game(opponent: .Columbia, city: "New York", state: "NY", date: Date.dateComponents(year: 2024, month: 5, day: 25, hour: 10, minute: 0), sport: .Lacrosse, address: "6 Fake St", sex: .Men)
    ]
}

