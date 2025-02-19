//
//  GamesViewModel.swift
//  score-ios
//
//  Created by Hsia Lu wu on 12/3/24.
//

import Foundation
import SwiftUI

class GamesViewModel: ObservableObject {

    private func getUpcomingGames(allGames: [Game]) -> [Game] {
        var upcomingGames: [Game] = []
        
        allGames.forEach { game in
            let now = Date()
            let twoHours: TimeInterval = 2 * 60 * 60
            let calendar = Calendar.current
            let startOfToday = calendar.startOfDay(for: now)
            
            let isLive = game.date < now && now.timeIntervalSince(game.date) <= twoHours
            let isUpcoming = game.date > now
            let isFinishedToday = game.date < now && game.date >= startOfToday
            
            if isLive {
                upcomingGames.insert(game, at: 0)
            } else if isUpcoming {
                upcomingGames.append(game)
            } else if isFinishedToday {
                upcomingGames.append(game)
            }
        }
        
        return upcomingGames
    }
    
    private func getPastGames(allGames: [Game]) -> [Game] {
        var pastGames: [Game] = []
        
        allGames.forEach { game in
            let now = Date()
            let calendar = Calendar.current
            let startOfToday = calendar.startOfDay(for: now)
            
            let isFinishedByToday = game.date < startOfToday
            
            if isFinishedByToday {
                if(!game.gameUpdates.isEmpty) {
                    pastGames.append(game)
                }
            }
        }
        return pastGames
    }
}
