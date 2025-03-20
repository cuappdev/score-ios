//
//  GamesViewModel.swift
//  score-ios
//
//  Created by Hsia Lu wu on 12/3/24.
//

import Foundation
import SwiftUI

class GamesViewModel: ObservableObject
{
    @Published var errorMessage: String?
    @Published var games: [Game] = [] // List of all games
    @Published var allUpcomingGames: [Game] = []
    @Published var allPastGames: [Game] = []
    
    // Carousel Logic
    @Published var selectedCardIndex: Int = 0
    @Published var topUpcomingGames: [Game] = [] // Displayed in Carousel
    @Published var topPastGames: [Game] = []
    
    // Filters Logic
    @Published var selectedSexIndex: Int = 0
    @Published var selectedSex : Sex = .Both
    @Published var selectedSport : Sport = .All
    @Published var selectedUpcomingGames: [Game] = [] // Based on the filters
    @Published var selectedPastGames: [Game] = []
    @Published var sportSelectorOffset: CGFloat = 0
    
    // Singleton structure so it is shared
    static let shared = GamesViewModel()
    private init() { }
    
    // Filtering the data
    func filter() {
        self.selectedUpcomingGames = self.allUpcomingGames.filter{ game in
            // Filter by sex
            let matchesSex = (selectedSex == .Both) || (game.sex == selectedSex)
            
            // Filter by sport
            let matchesSport = (selectedSport == .All) || (game.sport == selectedSport)
            
            // Return true if both filters are satisfied
            return matchesSex && matchesSport
        }
        self.selectedPastGames = self.allPastGames.filter{ game in
            // Filter by sex
            let matchesSex = (selectedSex == .Both) || (game.sex == selectedSex)
            
            // Filter by sport
            let matchesSport = (selectedSport == .All) || (game.sport == selectedSport)
            
            // Return true if both filters are satisfied
            return matchesSex && matchesSport
        }
    }
    
    // Networking
    func fetchGames() {
        NetworkManager.shared.fetchGames { fetchedGames, error in
            if let fetchedGames = fetchedGames {
                var updatedGames: [Game] = []
                fetchedGames.indices.forEach { index in
                    let gameData = fetchedGames[index]
                    let game = Game(game: gameData)
                    if Sport.allCases.contains(game.sport) && game.sport != Sport.All {
                        // append the game only if it is upcoming/live
                        let now = Date()
                        let twoHours: TimeInterval = 2 * 60 * 60
                        let calendar = Calendar.current
                        let startOfToday = calendar.startOfDay(for: now)
                        
                        let isLive = game.date < now && now.timeIntervalSince(game.date) <= twoHours
                        let isUpcoming = game.date > now
                        let isFinishedToday = game.date < now && game.date >= startOfToday
                        let isFinishedByToday = game.date < startOfToday
                        
                        updatedGames.append(game)
                        if isLive {
                            self.allUpcomingGames.insert(game, at: 0)
                        } else if isUpcoming {
                            self.allUpcomingGames.append(game)
                        } else if isFinishedToday {
                            self.allUpcomingGames.append(game)
                        }
                        if isFinishedByToday {
                            self.allPastGames.append(game)
                        }
                    }
                }
                // TODO: do this in a way that requires less copying by sorting at the top
                self.allPastGames.sort(by: {$0.date < $1.date})
                self.allUpcomingGames.sort(by: {$0.date < $1.date})
                self.games = updatedGames.sorted(by: {$0.date < $1.date})
                self.topUpcomingGames = Array(self.allUpcomingGames.prefix(3))
                self.topPastGames = Array(self.allPastGames.suffix(3))
                self.filter()
            }
            else if let error = error {
                self.errorMessage = error.localizedDescription
                print("Error in fetchGames: \(self.errorMessage ?? "Unknown error")")
            }
        }
        
    }
}
