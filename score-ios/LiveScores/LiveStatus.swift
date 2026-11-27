//
//  LiveStatus.swift
//  score-ios
//
//  The one place that decides whether a game is live and whether to listen for its scores.
//

import Foundation

enum LiveStatus {
    /// GraphQL does not expose `isLive`, so a game counts as live for this long after its start time.
    static let liveWindow: TimeInterval = 2 * 60 * 60
    /// The backend never clears `isLive`, so the socket flag only extends the window up to this cap.
    static let maxGameLength: TimeInterval = 6 * 60 * 60
    static let subscribeLeadTime: TimeInterval = 15 * 60
    static let subscribeTrailTime: TimeInterval = 3 * 60 * 60

    static func isLive(_ game: Game, now: Date = Date()) -> Bool {
        guard game.date < now else { return false }
        let elapsed = now.timeIntervalSince(game.date)
        return elapsed <= liveWindow || (game.isLive && elapsed <= maxGameLength)
    }

    /// Wider than `isLive` so the first plays are not missed and late-running games keep updating.
    static func shouldSubscribe(to game: Game, now: Date = Date()) -> Bool {
        guard game.serverId != nil else { return false }
        if isLive(game, now: now) { return true }
        let start = game.date.addingTimeInterval(-subscribeLeadTime)
        let end = game.date.addingTimeInterval(subscribeTrailTime)
        return now >= start && now <= end
    }
}
