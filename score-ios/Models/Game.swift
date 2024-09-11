//
//  Game.swift
//  score-ios
//
//  Created by Daniel on 9/11/24.
//

import SwiftUI

protocol GameType {
    // On Card and Details
    var opponent: Opponent { get }
    var city: String { get }
    var state: String { get }
    var date: Date { get }
    var sport: Sport { get }
    
    // On Details
    // TODO add more, maybe longitude and latitude for Transit integration? Idk
    var address: String { get }
}

struct Game : GameType {
    var opponent: Opponent
    var city: String
    var state: String
    var date: Date
    var sport: Sport
    var address: String
}

// Enums for various types
enum Opponent {
    case Penn
    case Princeton
    case Harvard
    case Yale
    case Brown
    case Dartmouth
    case Columbia
}

enum Sport {
    
    // https://health.cornell.edu/services/sports-medicine/sports-clearance/ncaa-teams
    
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
}

enum Sex {
    case Male
    case Female
}

// TEMP Dummy data
extension Game {
    static let dummyData: [Game] = [
        Game(opponent: .Princeton, city: "Princeton", state: "NJ", date: Date.stringToDate(string: "2024-5-20 10:00:00"), sport: .Basketball, address: "1 Fake St"),
        Game(opponent: .Harvard, city: "Cambridge", state: "MA", date: Date.stringToDate(string: "2024-5-21 10:00:00"), sport: .Football, address: "2 Fake St"),
        Game(opponent: .Yale, city: "New Haven", state: "CT", date: Date.stringToDate(string: "2024-5-22 10:00:00"), sport: .Soccer, address: "3 Fake St"),
        Game(opponent: .Brown, city: "Providence", state: "RI", date: Date.stringToDate(string: "2024-5-23 10:00:00"), sport: .CrossCountry, address: "4 Fake St"),
        Game(opponent: .Dartmouth, city: "Hanover", state: "NH", date: Date.stringToDate(string: "2024-5-24 10:00:00"), sport: .IceHockey, address: "5 Fake St"),
        Game(opponent: .Columbia, city: "New York", state: "NY", date: Date.stringToDate(string: "2024-5-25 10:00:00"), sport: .Lacrosse, address: "6 Fake St")
    ]
}
