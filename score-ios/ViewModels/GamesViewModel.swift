//
//  GamesViewModel.swift
//  score-ios
//
//  Created by Hsia Lu wu on 12/3/24.
//

import Foundation
import SwiftUI
import GameAPI

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

    // private games data
    private var privateGames: [Game] = []
    private var privateUpcomingGames: [Game] = []
    private var privatePastGames: [Game] = []

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
//    func fetchGames() {
//        // Set loading state before fetch
//        dataState = .loading
//
//        NetworkManager.shared.fetchGames { fetchedGames, error in
//            DispatchQueue.main.async {
//                self.games.removeAll()
//                self.allPastGames.removeAll()
//                self.allUpcomingGames.removeAll()
//
//                if let error = error {
//                    self.dataState = .error(error: .networkError)
//                    print("Error in fetchGames: \(error.localizedDescription)")
//                    return
//                }
//
//                guard let fetchedGames = fetchedGames else {
//                    self.dataState = .error(error: .emptyData)
//                    return
//                }
//
//                var updatedGames: [Game] = []
//                fetchedGames.indices.forEach { index in
//                    let gameData = fetchedGames[index]
//                    let game = Game(game: gameData)
//                    if Sport.allCases.contains(game.sport) && game.sport != Sport.All {
//                        // append the game only if it is upcoming/live
//                        let now = Date()
//                        let twoHours: TimeInterval = 2 * 60 * 60 // TODO: How to decide if a game is live
//                        let calendar = Calendar.current
//                        let startOfToday = calendar.startOfDay(for: now)
//
//                        let isLive = game.date < now && now.timeIntervalSince(game.date) <= twoHours
//                        let isUpcoming = game.date > now
//                        let isFinishedToday = game.date < now && game.date >= startOfToday
//                        let isFinishedByToday = game.date < startOfToday
//
//                        updatedGames.append(game)
//                        if isLive {
//                            self.allUpcomingGames.insert(game, at: 0)
//                        } else if isUpcoming {
//                            self.allUpcomingGames.append(game)
//                        } else if isFinishedToday {
//                            self.allUpcomingGames.append(game)
//                        }
//                        if isFinishedByToday {
//                            self.allPastGames.append(game)
//                        }
//                    }
//                }
//                // TODO: do this in a way that requires less copying by sorting at the top
//                self.allPastGames.sort(by: {$0.date > $1.date})
//                self.allUpcomingGames.sort(by: {$0.date < $1.date})
//                self.games = updatedGames.sorted(by: {$0.date < $1.date})
//                self.topUpcomingGames = Array(self.allUpcomingGames.prefix(3))
//                self.topPastGames = Array(self.allPastGames.prefix(3))
//                self.filter()
//
//                // Update state to success
//                self.dataState = .success
//            }
//        }
//    }

    // TODO: Remove once backend is has implemented pagination with sorted dates and pages by game type
    func fetchGames() {
        // Set loading state before fetch
        dataState = .loading
        // Clear the current arrays
        self.games.removeAll()
        self.allPastGames.removeAll()
        self.allUpcomingGames.removeAll()

        // Start fetching from the first page
        fetchGamesRecursively(limit: 50, offset: 0, accumulatedGames: [])
    }

    private func fetchGamesRecursively(limit: Int, offset: Int, accumulatedGames: [GamesQuery.Data.Game], retryCount: Int = 0, maxRetries: Int = 3) {
        // Create a timeout
        let timeoutWorkItem = DispatchWorkItem {
            print("Request timed out for offset: \(offset)")
            // If we haven't exceeded max retries, try again
            if retryCount < maxRetries {
                print("Retrying request (\(retryCount + 1)/\(maxRetries))...")
                DispatchQueue.main.async {
                    self.fetchGamesRecursively(limit: limit, offset: offset, accumulatedGames: accumulatedGames, retryCount: retryCount + 1, maxRetries: maxRetries)
                }
            } else {
                print("Max retries exceeded. Giving up on request for offset: \(offset)")
                DispatchQueue.main.async {
//                    // If this was the first request and it failed after all retries, show error
//                    if offset == 0 && accumulatedGames.isEmpty {
//                        self.dataState = .error(error: .networkError)
//                    } else {
//                        // Otherwise process what we have so far
//                        self.processGames(accumulatedGames)
//                    }
                    self.dataState = .error(error: .networkError)
                }
            }
        }

        // Schedule timeout
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: timeoutWorkItem)

        NetworkManager.shared.fetchGames(limit: limit, offset: offset) { [weak self] fetchedGames, error in
            guard let self = self else { return }

            // Cancel the timeout since we got a response
            timeoutWorkItem.cancel()

            DispatchQueue.main.async {
                if let error = error {
                    print("Error in fetchGames for offset \(offset): \(error.localizedDescription)")

                    // If we haven't exceeded max retries, try again
                    if retryCount < maxRetries {
                        print("Retrying request (\(retryCount + 1)/\(maxRetries))...")
                        self.fetchGamesRecursively(limit: limit, offset: offset, accumulatedGames: accumulatedGames, retryCount: retryCount + 1, maxRetries: maxRetries)
                    } else {
                        print("Max retries exceeded. Giving up on request for offset: \(offset)")
                        // If this was the first request and it failed after all retries, show error
                        if offset == 0 && accumulatedGames.isEmpty {
                            self.dataState = .error(error: .networkError)
                        } else {
                            // Otherwise process what we have so far
                            self.processGames(accumulatedGames)
                        }
                    }
                    return
                }

                guard let fetchedGames = fetchedGames, !fetchedGames.isEmpty else {
                    // If this is the first fetch and no games, show empty data error
                    if offset == 0 {
                        self.dataState = .error(error: .emptyData)
                    } else {
//                        // Otherwise process all accumulated games
//                        self.processGames(accumulatedGames)
                        self.dataState = .error(error: .networkError)
                    }
                    return
                }

                // Combine newly fetched games with previously accumulated games
                let allGames = accumulatedGames + fetchedGames

                // If we received a full page, there might be more games to fetch
                if fetchedGames.count == limit {
                    // Continue fetching the next page (reset retry count for the next page)
                    self.fetchGamesRecursively(limit: limit, offset: offset + limit, accumulatedGames: allGames, retryCount: 0, maxRetries: maxRetries)
                } else {
                    // We've fetched all games, process them
                    self.processGames(allGames)
                }
            }
        }
    }

    private func processGames(_ gameDataArray: [GamesQuery.Data.Game]) {
        var updatedGames: [Game] = []
        gameDataArray.indices.forEach { index in
            let gameData = gameDataArray[index]
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
                    self.privateUpcomingGames.insert(game, at: 0)
                } else if isUpcoming {
                    self.privateUpcomingGames.append(game)
                } else if isFinishedToday {
                    self.privateUpcomingGames.append(game)
                }
                if isFinishedByToday {
                    self.privatePastGames.append(game)
                }
            }
        }

        // Filter out duplicates before sorting
        self.allPastGames = uniqueGames(from: self.privatePastGames)
        self.allUpcomingGames = uniqueGames(from: self.privateUpcomingGames)
        self.games = uniqueGames(from: updatedGames)

        // Sort all the collections
        self.allPastGames.sort(by: {$0.date > $1.date})
        self.allUpcomingGames.sort(by: {$0.date < $1.date})
        self.games = updatedGames.sorted(by: {$0.date < $1.date})
        self.topUpcomingGames = Array(self.allUpcomingGames.prefix(3))
        self.topPastGames = Array(self.allPastGames.prefix(3))
        self.filter()

        // Update state to success
        self.dataState = .success
    }

    // Function to filter out duplicate games by ID
    func uniqueGames(from games: [Game]) -> [Game] {
        var uniqueGames: [Game] = []
        var seenIDs: Set<String> = []

        for game in games {
            if let id = game.serverId, !seenIDs.contains(id) {
                uniqueGames.append(game)
                seenIDs.insert(id)
            }
        }

        return uniqueGames
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
