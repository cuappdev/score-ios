//
//  LiveGameStore.swift
//  score-ios
//
//  Latest live update per game, layered over fetched games.
//

import Combine
import Foundation

@MainActor
final class LiveGameStore: ObservableObject {
    static let shared: LiveGameStore = {
        let store = LiveGameStore()
        store.watch(GamesViewModel.shared.$games)
        return store
    }()

    /// Kept separate from fetched games so a GraphQL refresh does not wipe live box scores.
    @Published private(set) var updates: [String: LiveGameUpdate] = [:]

    private let client: LiveScoreClient
    private var listenTask: Task<Void, Never>?
    private var gamesSubscription: AnyCancellable?
    private var latestGames: [Game] = []
    /// Ids subscribed on behalf of the game lists. Screens hold their own references through `track`.
    private var listTrackedIds: Set<String> = []

    init(client: LiveScoreClient = LiveScoreClient()) {
        self.client = client
        listenTask = Task { [weak self, updates = client.updates] in
            for await update in updates {
                self?.apply(update)
            }
        }
    }

    deinit {
        listenTask?.cancel()
    }

    func update(for game: Game) -> LiveGameUpdate? {
        game.serverId.flatMap { updates[$0] }
    }

    func resolve(_ game: Game) -> Game {
        guard let update = update(for: game) else { return game }
        return game.applying(update)
    }

    func apply(_ update: LiveGameUpdate) {
        updates[update.gameId] = update
    }

    func track(gameId: String) {
        client.subscribe(gameId: gameId)
    }

    func untrack(gameId: String) {
        client.unsubscribe(gameId: gameId)
    }

    func suspend() {
        client.suspend()
    }

    /// Re-evaluates list subscriptions too, since games may have entered or left the live window while away.
    func resume() {
        syncListSubscriptions(with: latestGames)
        client.resume()
    }

    private func watch(_ games: Published<[Game]>.Publisher) {
        gamesSubscription = games.sink { [weak self] games in
            self?.syncListSubscriptions(with: games)
        }
    }

    private func syncListSubscriptions(with games: [Game]) {
        latestGames = games
        let now = Date()
        let wanted = Set(games.filter { LiveStatus.shouldSubscribe(to: resolve($0), now: now) }.compactMap(\.serverId))

        for id in listTrackedIds.subtracting(wanted) {
            untrack(gameId: id)
        }
        for id in wanted.subtracting(listTrackedIds) {
            track(gameId: id)
        }
        listTrackedIds = wanted
    }
}
