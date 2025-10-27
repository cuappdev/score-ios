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
        case .Baseball: return game.timeUpdates.count > 3 ? game.timeUpdates.count - 3 : 9
            // number of innings is not always 9
        case .Soccer: return 2
        case .IceHockey: return 3
        case .FieldHockey, .Football, .Lacrosse: return 4
        default: return 1
        }
    }
    
    var numberOfColumns: Int {
        switch game.sport {
        case .Baseball: return game.timeUpdates.count > 3 ? game.timeUpdates.count - 2 : 10
            // the last three columns are total runs, hits, and errors
            // if backend stores null for scoreBreakdown, display regular score box with 10 columns
        case .Soccer: return game.timeUpdates.count >= 3 ? game.timeUpdates.count : 3
        case .IceHockey: return game.timeUpdates.count
        case .FieldHockey, .Football, .Lacrosse: return game.timeUpdates.count >= 5 ? game.timeUpdates.count : 5
        default: return 1
        }
    }
    
    var numberOfOvertimes: Int {
        switch game.sport {
        case .Baseball: return -1
        case .Soccer: return game.timeUpdates.count - 3
        case .IceHockey: return game.timeUpdates.count - 3
        case .FieldHockey, .Football, .Lacrosse: return game.timeUpdates.count - 5
        default: return -1
        }
    }
    
    
    var cornellTotalScore: Int {
        // TODO: Get this back when backend fixes the boxScore (make sure the last entry reflects total score correctly)
//        return game.gameUpdates.count > 0 ? game.gameUpdates[game.gameUpdates.count - 1].cornellScore : -1
        if game.sport == .Baseball {
            return game.gameUpdates.count > 0 ? game.gameUpdates[game.gameUpdates.count - 1].cornellScore : -1
        }
        
        return game.timeUpdates.count > 0 ? game.timeUpdates[game.timeUpdates.count - 1].cornellScore : -1
    }
    
    var opponentTotalScore: Int {
        // TODO: Get this back when backend fixes the boxScore (make sure the last entry reflects total score correctly)
//        return game.gameUpdates.count > 0 ? game.gameUpdates[game.gameUpdates.count - 1].opponentScore : -1
        if game.sport == .Baseball {
            return game.gameUpdates.count > 0 ? game.gameUpdates[game.gameUpdates.count - 1].opponentScore : -1
        }
        
        return game.timeUpdates.count > 0 ? game.timeUpdates[game.timeUpdates.count - 1].opponentScore : -1
    }
    
    var corScore: String {
        return (cornellTotalScore == -1) ? "-" : "\(cornellTotalScore)"
    }
    
    var oppScore: String {
        return (opponentTotalScore == -1) ? "-" : "\(opponentTotalScore)"
    }
    
    init(game: Game) {
        self.game = game
    }
}
