//
//  GameView.swift
//  score-ios
//
//  Created by Mac User on 9/15/24.
//

import SwiftUI

struct GameView : View {
    var game : Game
    
    var body : some View {
        Text(game.sport.rawValue)
    }
}
