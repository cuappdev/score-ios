//
//  GamesCacheManager.swift
//  score-ios
//
//  Created by Jayson Hahn on 4/29/25.
//

import Foundation
import GameAPI

// Represents the type of games tab
enum GameTimeframe {
    case past
    case upcoming
}

class GamesCacheManager {

    static let shared = GamesCacheManager()

    private var pastGames: [GamesQuery.Data.Game] = []
    private var upcomingGames: [GamesQuery.Data.Game] = []

    // Keep track of pagination state
    private var currentOffset = 0
    private var isLoading = false
    private var hasMoreData = true

    private var allGameIds: Set<String> = []

    // Page size for each tab
    private let defaultPageSize = 10

    // Initialize with empty cache
    private init() {}

    // Get cached games by type with specified limit
    func getGames(type: GameTimeframe, limit: Int) -> [GamesQuery.Data.Game] {
        switch type {
        case .past:
            return Array(pastGames.prefix(limit))
        case .upcoming:
            return Array(upcomingGames.prefix(limit))
        }
    }

    // Check if we have enough games of the specified type
    func hasEnoughGames(type: GameTimeframe, count: Int) -> Bool {
        switch type {
        case .past:
            return pastGames.count >= count
        case .upcoming:
            return upcomingGames.count >= count
        }
    }

    // TODO: Revise then when backend sorts games by date
    // Load more games of the specified type
    func loadMoreGames(type: GameTimeframe, pageSize: Int, completion: @escaping ([GamesQuery.Data.Game]?, Error?) -> Void) {
        // If already loading or no more data, return
        guard !isLoading && hasMoreData else {
            completion([], nil)
            return
        }

        // If we already have enough games cached, just return from cache
        if hasEnoughGames(type: type, count: getNextPageIndex(type: type) + pageSize) {
            let startIndex = getNextPageIndex(type: type)
            let endIndex = min(startIndex + pageSize, type == .past ? pastGames.count : upcomingGames.count)
            let gamesPage = Array((type == .past ? pastGames : upcomingGames)[startIndex..<endIndex])
            completion(gamesPage, nil)
            return
        }

        // Otherwise load more from the network
        loadMoreFromNetwork(desiredType: type, desiredCount: pageSize, completion: completion)
    }

    // Get the next page start index for the specified type
    private func getNextPageIndex(type: GameTimeframe) -> Int {
        switch type {
        case .past:
            return pastGames.count
        case .upcoming:
            return upcomingGames.count
        }
    }

    // TODO: Revise then when backend sorts games by date
    // Load more games from the network with increasing batch size until we have enough
    private func loadMoreFromNetwork(desiredType: GameTimeframe, desiredCount: Int, completion: @escaping ([GamesQuery.Data.Game]?, Error?) -> Void) {
        isLoading = true

        // Calculate how many more games we need - use a multiplier since we don't know how many will be of each type
        let requestLimit = max(desiredCount * 3, 20) // Request more than needed to account for filtering

        NetworkManager.shared.fetchGames(limit: requestLimit, offset: currentOffset) { [weak self] games, error in
            guard let self = self else { return }

            self.isLoading = false

            if let error = error {
                completion(nil, error)
                return
            }

            guard let games = games else {
                completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No games returned"]))
                return
            }

            // If no games returned, we've reached the end
            if games.isEmpty {
                self.hasMoreData = false
                completion([], nil)
                return
            }

            // Sort games into past and upcoming categories using updated logic
            let now = Date()
            let twoHours: TimeInterval = 2 * 60 * 60 // For determining live games
            let calendar = Calendar.current
            let startOfToday = calendar.startOfDay(for: now)

            var newPastGames: [GamesQuery.Data.Game] = []
            var newUpcomingGames: [GamesQuery.Data.Game] = []

            for game in games {
                // TODO: make utc date not optional on backend
                if let gameDate = self.parseDate(from: game.date) {
                    // Check if game is live (started but within 2 hours)
                    let isLive = gameDate < now && now.timeIntervalSince(gameDate) <= twoHours

                    // Check if game is upcoming (hasn't started yet)
                    let isUpcoming = gameDate > now

                    // Check if game finished today
                    let isFinishedToday = gameDate < now && gameDate >= startOfToday

                    // Check if game finished before today
                    let isFinishedByToday = gameDate < startOfToday

                    // Apply sorting logic
                    if isLive || isUpcoming || isFinishedToday {
                        // Live games should be at the beginning of upcoming games list
                        if isLive {
                            // Insert at beginning of upcoming games
                            newUpcomingGames.insert(game, at: 0)
                        } else {
                            // Regular upcoming or finished today games
                            newUpcomingGames.append(game)
                        }
                    }

                    if isFinishedByToday {
                        newPastGames.append(game)
                    }
                }
            }

            // Update the cache
            self.pastGames.append(contentsOf: newPastGames)
            self.upcomingGames.append(contentsOf: newUpcomingGames)

            // Update the offset for the next request
            self.currentOffset += games.count

            // Determine which games to return based on the requested type
            var gamesForType: [GamesQuery.Data.Game] = []
            let startIndex = desiredType == .past ? self.pastGames.count - newPastGames.count : self.upcomingGames.count - newUpcomingGames.count
            let allGamesOfType = desiredType == .past ? self.pastGames : self.upcomingGames

            if startIndex < allGamesOfType.count {
                let endIndex = min(startIndex + desiredCount, allGamesOfType.count)
                gamesForType = Array(allGamesOfType[startIndex..<endIndex])
            }

            // If we don't have enough games of the requested type yet and there might be more
            if gamesForType.count < desiredCount && self.hasMoreData {
                // Recursively fetch more
                self.loadMoreFromNetwork(desiredType: desiredType, desiredCount: desiredCount, completion: completion)
            } else {
                // We have enough or there's no more data
                completion(gamesForType, nil)
            }
        }
    }

    // Helper to parse date from game object
    private func parseDate(from dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXX"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.date(from: dateString)
    }

    // Refresh the cache (e.g., on pull to refresh)
    func refreshCache(completion: @escaping (Error?) -> Void) {
        pastGames = []
        upcomingGames = []
        currentOffset = 0
        hasMoreData = true

        // Load initial data
        NetworkManager.shared.fetchGames(limit: defaultPageSize * 2, offset: 0) { [weak self] games, error in
            guard let self = self else { return }

            if let error = error {
                completion(error)
                return
            }

            guard let games = games else {
                completion(nil)
                return
            }

            // Sort games into past and upcoming
            let now = Date()
            for game in games {
                if let gameDate = self.parseDate(from: game.date), gameDate < now {
                    self.pastGames.append(game)
                } else {
                    self.upcomingGames.append(game)
                }
            }

            self.currentOffset = games.count
            completion(nil)
        }
    }

}
