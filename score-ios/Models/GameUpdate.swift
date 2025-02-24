//
//  GameUpdate.swift
//  score-ios
//
//  Created by Daniel Chuang on 2/23/25.
//

import SwiftUI

struct GameUpdate : Hashable {
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
