//
//  BoxScoreUpdate.swift
//  score-ios
//
//  Created by Daniel Chuang on 2/23/25.
//

import SwiftUI
import GameAPI

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
            self.time = item.time ?? "--:--"
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
