//
//  GamesViewModel.swift
//  score-ios
//
//  Created by Hsia Lu wu on 12/3/24.
//

import Foundation
import SwiftUI

class GamesViewModel: ObservableObject {
//    @Published var allGames: [Game] = []
//    @Published var upcomingGames: [Game] = []
//    @Published var pastGames: [Game] = []
    
    init() {
//        fetchAllGames { [weak self] game in
//            DispatchQueue.main.async {
//                self?.allGames = games
//            }
//        }
    }
    
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

//func fetchAllGames() -> [Game] {
//    var games: [Game] = []
//    NetworkManager.shared.fetchGames { fetchedGames, error in
//        if let fetchedGames = fetchedGames {
//            var updatedGames: [Game] = []
//            let dispatchGroup = DispatchGroup()
//            
//            fetchedGames.forEach { gameData in
//                let game = Game(game: gameData)
//                dispatchGroup.enter() // enter the dispatchGroup
//                
//                game.fetchAndUpdateOpponent(opponentId: gameData.opponentId) { updatedGame in
//                    updatedGames.append(updatedGame)
//                    print("UpdatedGame: \(updatedGame.sport) game with \(updatedGame.opponent.name)")
//                    dispatchGroup.leave()
//                }
//            }
//            
//            dispatchGroup.notify(queue: .main) {
//                games = updatedGames
//            }
//            print(games.isEmpty)
//            games.forEach { game in
//                print("Game: \(game.sport) game with \(game.opponent.name)")
//            }
//        }
//        else if let error = error {
//            print("Error in fetchAllGames: \(error.localizedDescription)")
//        }
//    }
//    return games
//}

//func fetchAllGames(completion: @escaping ([Game]) -> Void) -> [Game] {
//    var games: [Game] = []
//    NetworkManager.shared.fetchGames { fetchedGames, error in
//        if let fetchedGames = fetchedGames {
//            var updatedGames: [Game] = []
//            let dispatchGroup = DispatchGroup()
//            
//            fetchedGames.forEach { gameData in
//                let game = Game(game: gameData)
//                dispatchGroup.enter() // enter the dispatchGroup
//                
//                    game.fetchAndUpdateOpponent(opponentId: gameData.opponentId) { updatedGame in
//                    updatedGames.append(updatedGame)
//                    print("UpdatedGame: \(updatedGame.sport) game with \(updatedGame.opponent.name)")
//                    dispatchGroup.leave()
//                }
//            }
//            
//            dispatchGroup.notify(queue: .main) {
//                games = updatedGames
//                completion(updatedGames)
//            }
//        }
//        else if let error = error {
//            print("Error in fetchAllGames: \(error.localizedDescription)")
//            completion([])
//        }
//    }
//}
