//
//  GamesViewModel.swift
//  score-ios
//
//  Created by Hsia Lu wu on 12/3/24.
//

import Foundation
import SwiftUI

// State enum to track the loading state
enum DataState {
    case idle        // Initial state, nothing has been fetched yet
    case loading     // Fetch in progress
    case success     // Fetch completed successfully
    case error(error: ScoreError) // Fetch failed with an error message
}

class GamesViewModel: ObservableObject
{
    @Published var dataState: DataState = .idle
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

    var hasNotFetchedYet: Bool {
        return dataState == .idle
    }

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
        // Set loading state before fetch
        dataState = .loading

        NetworkManager.shared.fetchGames { fetchedGames, error in
            DispatchQueue.main.async {
                self.games.removeAll()
                self.allPastGames.removeAll()
                self.allUpcomingGames.removeAll()

                if let error = error {
                    self.dataState = .error(error: .networkError)
                    print("Error in fetchGames: \(error.localizedDescription)")
                    return
                }

                guard let fetchedGames = fetchedGames else {
                    self.dataState = .error(error: .emptyData)
                    return
                }

                var updatedGames: [Game] = []
                fetchedGames.indices.forEach { index in
                    let gameData = fetchedGames[index]
                    let game = Game(game: gameData)
                    if Sport.allCases.contains(game.sport) && game.sport != Sport.All {
                        // append the game only if it is upcoming/live
                        let now = Date()
                        let twoHours: TimeInterval = 2 * 60 * 60 // TODO: How to decide if a game is live
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

                // Update state to success
                self.dataState = .success
            }
        }
    }

    // Method to retry after an error
    func retryFetch() {
        fetchGames()
    }
}

extension DataState: Equatable {
    
    static func == (lhs: DataState, rhs: DataState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.loading, .loading):
            return true
        case (.success, .success):
            return true
        case (.error(let lhsError), .error(let rhsError)):
            if lhsError == rhsError {
                return true
            } else {
                return false
            }
        default:
            return false
        }
    }

}
