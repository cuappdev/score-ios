//
//  Sport.swift
//  score-ios
//
//  Created by Daniel Chuang on 2/23/25.
//

import SwiftUI

enum Sport : String, Identifiable, CaseIterable, CustomStringConvertible {
    // https://health.cornell.edu/services/sports-medicine/sports-clearance/ncaa-teams
    var id: Self { self }
    
    case All
    
    // Both
    case Basketball
//    case CrossCountry
    case IceHockey
    case Lacrosse
    case Soccer
//    case Squash
//    case SwimmingDiving
//    case Tennis
//    case TrackField
    
    // Women
//    case Fencing
    case FieldHockey
//    case Gymnastics
//    case Rowing
//    case Sailing
    case Softball
    case Volleyball
    
    // Men
    case Baseball
    case Football
//    case Golf
//    case RowingHeavyweight
//    case RowingLightweight
    case SprintFootball
//    case Wrestling
    
    // init from a string from backend (might include spaces)
    init?(normalizedValue: String) {
        // Normalize the input by removing spaces and making it case insensitive
        let cleanedValue = normalizedValue.replacingOccurrences(of: " ", with: "").lowercased()
        for sport in Sport.allCases {
            if sport.rawValue.lowercased() == cleanedValue {
                self = sport
                return
            }
        }
        return nil
    }
    
    // Make a to string function
    var description: String {
        switch self {
        case .All:
            return "All"
        case .Basketball:
            return "Basketball"
//        case .CrossCountry:
//            return "Cross Country"
        case .IceHockey:
            return "Ice Hockey"
        case .Lacrosse:
            return "Lacrosse"
        case .Soccer:
            return "Soccer"
//        case .Squash:
//            return "Squash"
//        case .SwimmingDiving:
//            return "Swimming"
//        case .Tennis:
//            return "Tennis"
//        case .TrackField:
//            return "Track and Field"
//        case .Fencing:
//            return "Fencing"
        case .FieldHockey:
            return "Field Hockey"
//        case .Gymnastics:
//            return "Gymnastics"
//        case .Rowing:
//            return "Rowing"
//        case .Sailing:
//            return "Sailing"
        case .Softball:
            return "Softball"
        case .Volleyball:
            return "Volleyball"
        case .Baseball:
            return "Baseball"
        case .Football:
            return "Football"
//        case .Golf:
//            return "Golf"
//        case .RowingHeavyweight:
//            return "HW Rowing"
//        case .RowingLightweight:
//            return "LW Rowing"
        case .SprintFootball:
            return "Sprint Football"
//        case .Wrestling:
//            return "Wrestling"
        }
    }
}

