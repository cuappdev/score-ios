//
//  ContentView.swift
//  score-ios
//
//  Created by Daniel Chuang on 9/4/24.
//

import SwiftUI
import GameAPI

/// Main View of the app
struct ContentView: View {
    
    @State private var selectedTab: Int = 0
    @State private var games: [GamesQuery.Data.Game] = []
    @State private var errorMessage: String?
    
    var body: some View {
        
        MainTabView(selection: $selectedTab)
    }
    
    private func fetchGames() {
        NetworkManager.shared.fetchGames { fetchedGames, error in
            if let fetchedGames = fetchedGames {
                games = fetchedGames
                // Print game info to the console
                games.forEach { game in
                    print("Game in \(game.city) on \(game.date), sport: \(game.sport), result: \(game.result ?? "N/A")")
                }
            } else if let error = error {
                errorMessage = error.localizedDescription
                print("Error fetching games: \(errorMessage ?? "Unknown error")")
            }
        }
    }
    
    private func filterGames() {
        NetworkManager.shared.filterUpcomingGames(gender: "Mens", sport: "Football") { filteredGames, error in
            if let filteredGames = filteredGames {
                games = filteredGames
                games.forEach { game in
                    print("Game in \(game.city) on \(game.date), sport: \(game.sport), result: \(game.result ?? "N/A")")
                }
            } else if let error = error {
                errorMessage = error.localizedDescription
                print("Error fetching games: \(errorMessage ?? "Unknown error")")
            }
        }
    }
}

#Preview {
    StateWrapper()
}

struct StateWrapper: View {
    @State private var selectedTab: Int = 0
    
    var body: some View {
        MainTabView(selection: $selectedTab)
    }
}
