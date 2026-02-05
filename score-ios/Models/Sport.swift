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
    case IceHockey
    case Lacrosse
    case Soccer
    
    // Women
    case FieldHockey
    
    // Men
    case Baseball
    case Football
    
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
        case .All: return "All"
        case .Basketball: return "Basketball"
        case .IceHockey: return "Ice Hockey"
        case .Lacrosse: return "Lacrosse"
        case .Soccer: return "Soccer"
        case .FieldHockey: return "Field Hockey"
        case .Baseball: return "Baseball"
        case .Football: return "Football"
        }
    }
}

