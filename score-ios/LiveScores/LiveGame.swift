//
//  LiveGame.swift
//  score-ios
//
//  SwiftUI helpers for reading and subscribing to live scores.
//

import SwiftUI

/// A game with the latest live update layered on top. Re-renders the view when that update changes.
/// `$game` is the raw update, for use with `.onChange`.
@propertyWrapper
struct LiveGame: DynamicProperty {
    @ObservedObject private var store = LiveGameStore.shared
    private let game: Game

    init(wrappedValue: Game) {
        self.game = wrappedValue
    }

    var wrappedValue: Game {
        store.resolve(game)
    }

    var projectedValue: LiveGameUpdate? {
        store.update(for: game)
    }
}

private struct LiveScoresModifier: ViewModifier {
    let game: Game
    @State private var trackedGameId: String?

    func body(content: Content) -> some View {
        content
            .onAppear {
                guard trackedGameId == nil,
                      let serverId = game.serverId,
                      LiveStatus.shouldSubscribe(to: game) else { return }
                trackedGameId = serverId
                LiveGameStore.shared.track(gameId: serverId)
            }
            .onDisappear {
                guard let serverId = trackedGameId else { return }
                trackedGameId = nil
                LiveGameStore.shared.untrack(gameId: serverId)
            }
    }
}

extension View {
    /// Keeps a socket subscription for `game` while this view is on screen, if the game is live or about to start.
    func liveScores(for game: Game) -> some View {
        modifier(LiveScoresModifier(game: game))
    }
}
