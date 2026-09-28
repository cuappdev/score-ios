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
    case loading     // Fetch in progress with nothing useful to show yet
    case success     // Fetch completed successfully (may be empty)
    case error(error: ScoreError) // Fetch failed and we have no content to keep showing
}

@MainActor
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

    /// Starting ±15d load
    private var loadTask: Task<Void, Never>?
    /// Disconnected ±1y month expand. 
    private var backgroundExpandTask: Task<Void, Never>?

    private static let initialWindowDays = 15
    private static let backgroundHorizonYears = 1

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

    /// Loads the 30d window, then kicks off a disconnected background expand to 2y.
    /// Returns when the 30d fetch finishes (loading spinner / pull-to-refresh end here).
    /// Expand keeps running afterward and is not part of this await.
    func loadGames(forceNetwork: Bool = false) async {
        loadTask?.cancel()
        backgroundExpandTask?.cancel()

        let task = Task { [weak self] in
            guard let self else { return }
            await self.fetchInitialWindow(forceNetwork: forceNetwork)
        }
        loadTask = task
        await task.value
    }

    /// ±15d fetch only. On success, spawns `backgroundExpandTask` and returns.
    private func fetchInitialWindow(forceNetwork: Bool) async {
        // Soft refresh: keep existing UI on screen; first load shows the loading spinner.
        let preserveExistingUI = (dataState == .success)
        if !preserveExistingUI {
            dataState = .loading
        }

        let now = Date()
        let windowStart = Date.dateByAdding(days: -Self.initialWindowDays, to: now)
        let windowEnd = Date.dateByAdding(days: Self.initialWindowDays, to: now)
        let initialWindow = windowStart...windowEnd

        do {
            let fetched = try await NetworkManager.shared.fetchGamesByDate(
                startDate: windowStart,
                endDate: windowEnd,
                forceNetwork: forceNetwork
            )
            if Task.isCancelled { return }

            let mapped = fetched.map { Game(game: $0) }

            if mapped.isEmpty {
                if preserveExistingUI {
                    dataState = .success
                } else {
                    dataState = .error(error: .emptyData)
                    return
                }
            } else if preserveExistingUI {
                removeGames(in: initialWindow)
                processGames(mapped, replace: false)
            } else {
                processGames(mapped, replace: true)
            }

            // Disconnected from the awaited load — UI spinner is already done.
            backgroundExpandTask = Task { [weak self] in
                guard let self else { return }
                await self.expandGamesInBackground(
                    around: now,
                    skipping: initialWindow,
                    forceNetwork: forceNetwork
                )
            }
        } catch is CancellationError {
            // Superseded by a newer load — leave dataState alone.
        } catch {
            if preserveExistingUI {
                dataState = .success
            } else {
                dataState = .error(error: .networkError)
            }
        }
    }

    /// Loads month-sized chunks covering ±1 year, merging into existing lists.
    /// Chunks that overlap the already-fetched ±15d window are clipped so we don't re-fetch it.
    private func expandGamesInBackground(
        around now: Date,
        skipping alreadyFetched: ClosedRange<Date>,
        forceNetwork: Bool
    ) async {
        let calendar = Calendar.current
        let horizonStart = Date.dateByAdding(years: -Self.backgroundHorizonYears, to: now)
        let horizonEnd = Date.dateByAdding(years: Self.backgroundHorizonYears, to: now)

        var monthStart = Date.startOfMonth(for: horizonStart)

        while monthStart < horizonEnd {
            if Task.isCancelled { return }

            guard let nextMonth = calendar.date(byAdding: .month, value: 1, to: monthStart) else {
                break
            }
            let monthEnd = min(nextMonth, horizonEnd)
            let ranges = Self.fetchRanges(from: monthStart, to: monthEnd, excluding: alreadyFetched)

            for range in ranges {
                if Task.isCancelled { return }
                do {
                    let fetched = try await NetworkManager.shared.fetchGamesByDate(
                        startDate: range.lowerBound,
                        endDate: range.upperBound,
                        forceNetwork: forceNetwork
                    )
                    let mapped = fetched.map { Game(game: $0) }
                    if !mapped.isEmpty {
                        processGames(mapped, replace: false)
                    }
                } catch is CancellationError {
                    return
                } catch {
                    // Skip failed chunk; keep expanding.
                }
            }

            monthStart = nextMonth
        }
    }

    /// Splits `[start, end]` into sub-ranges that do not overlap `excluding`.
    /// Boundary endpoints may be requested twice (inclusive API); `uniqueGames` dedupes.
    private static func fetchRanges(
        from start: Date,
        to end: Date,
        excluding: ClosedRange<Date>
    ) -> [ClosedRange<Date>] {
        guard start < end else { return [] }

        if end <= excluding.lowerBound || start >= excluding.upperBound {
            return [start...end]
        }
        if start >= excluding.lowerBound && end <= excluding.upperBound {
            return []
        }

        var ranges: [ClosedRange<Date>] = []
        if start < excluding.lowerBound {
            ranges.append(start...excluding.lowerBound)
        }
        if end > excluding.upperBound {
            ranges.append(excluding.upperBound...end)
        }
        return ranges
    }

    /// Drops cached games whose `date` falls in `range` (used to refresh the ±15d slice in place).
    private func removeGames(in range: ClosedRange<Date>) {
        privateUpcomingGames.removeAll { range.contains($0.date) }
        privatePastGames.removeAll { range.contains($0.date) }
    }

    private func processGames(_ incoming: [Game], replace: Bool) {
        if replace {
            privateUpcomingGames.removeAll()
            privatePastGames.removeAll()
        }

        for game in incoming {
            if Sport.allCases.contains(game.sport) && game.sport != Sport.All {
                let now = Date()
                let twoHours: TimeInterval = 2 * 60 * 60 // TODO: How to decide if a game is live
                let calendar = Calendar.current
                let startOfToday = calendar.startOfDay(for: now)
                let isLive = game.date < now && now.timeIntervalSince(game.date) <= twoHours
                let isUpcoming = game.date > now
                let isFinishedToday = game.date < now && game.date >= startOfToday
                let isFinishedByToday = game.date < startOfToday

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
        self.games = uniqueGames(from: self.allPastGames + self.allUpcomingGames)

        // Sort all the collections
        self.allPastGames.sort(by: {$0.date > $1.date})
        self.allUpcomingGames.sort(by: {$0.date < $1.date})
        self.games.sort(by: {$0.date < $1.date})
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
