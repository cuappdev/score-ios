//
//  PastGameViewModel.swift
//  score-ios
//
//  Created by Hsia Lu wu on 3/5/25.
//

import Foundation
import SwiftUI

class PastGameViewModel: ObservableObject {
    let game: Game
    
    var numberOfRounds: Int {
        switch game.sport {
        case .Baseball: return 9
        case .Basketball, .Soccer, .Volleyball: return 2
        case .IceHockey: return 3
        case .FieldHockey, .Football, .Lacrosse, .SprintFootball: return 4
        default: return 1
        }
    }
    
    // TODO: will be discarded once backend is changed to include a total score in scoreBreakdown for all sports
    var cornellTotalScore: Int {
        if game.timeUpdates.count == numberOfRounds {
            return game.timeUpdates.reduce(0, { $0 + $1.cornellScore }) // sum up the score for each round
        } else if game.timeUpdates.count == numberOfRounds + 1 {
            // the last one is the sum
            return game.timeUpdates[game.timeUpdates.count-1].cornellScore
        } else if game.timeUpdates.count > numberOfRounds {
            let scores = game.timeUpdates[0..<numberOfRounds]
            return scores.reduce(0, { $0 + $1.cornellScore }) // sum up the score for each round
        }
        else {
            return -1
        }
    }
    
    var opponentTotalScore: Int {
        if game.timeUpdates.count == numberOfRounds {
            return game.timeUpdates.reduce(0, { $0 + $1.opponentScore })
        } else if game.timeUpdates.count == numberOfRounds + 1 {
            // the last one is the sum
            return game.timeUpdates[game.timeUpdates.count-1].opponentScore
        } else if game.timeUpdates.count > numberOfRounds {
            let scores = game.timeUpdates[0..<numberOfRounds]
            return scores.reduce(0, { $0 + $1.opponentScore }) // sum up the score for each round
        } else {
            return -1
        }
    }
    
    init(game: Game) {
        self.game = game
    }
    
}
