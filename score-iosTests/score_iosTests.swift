//
//  score_iosTests.swift
//  score-iosTests
//
//  Created by Daniel Chuang on 9/4/24.
//

import XCTest
@testable import score_ios

final class score_iosTests: XCTestCase {

    private let sampleGameUpdate = """
    {
      "type": "game_update",
      "gameId": "abc123",
      "timestamp": "2026-11-26T23:00:00.123456-05:00",
      "data": {
        "gameId": "abc123",
        "isLive": true,
        "lastUpdated": "2026-11-26T23:00:01.654321-05:00",
        "boxScore": [
          {
            "play_id": "1",
            "team": "COR",
            "period": "1st",
            "time": null,
            "description": "Smith scores",
            "scorer": "Smith",
            "assist": null,
            "score_by": "Smith",
            "cor_score": "1",
            "opp_score": 0
          },
          {
            "play_id": 2,
            "team": "HAR",
            "period": 2,
            "time": "12:00",
            "description": "Jones scores",
            "scorer": "Jones",
            "assist": "Lee",
            "score_by": "Jones",
            "cor_score": 1,
            "opp_score": "2"
          }
        ],
        "scoreBreakdown": [["1", "0"], ["0", "2"]],
        "result": "Cornell 1, Harvard 2"
      }
    }
    """

    func testSocketURLDropsGraphQLPath() throws {
        let base = try XCTUnwrap(URL(string: "https://score-dev.cornellappdev.com/graphql"))
        XCTAssertEqual(
            ScoreEnvironment.socketURL(from: base).absoluteString,
            "https://score-dev.cornellappdev.com"
        )
        let slashed = try XCTUnwrap(URL(string: "https://score-dev.cornellappdev.com/graphql/"))
        XCTAssertEqual(
            ScoreEnvironment.socketURL(from: slashed).absoluteString,
            "https://score-dev.cornellappdev.com"
        )
    }

    func testDecodeGameUpdateSnakeCaseNullTime() throws {
        let message = try decodeSampleUpdate()
        XCTAssertEqual(message.gameId, "abc123")
        XCTAssertEqual(message.data.boxScore.count, 2)

        let first = message.data.boxScore[0]
        XCTAssertEqual(first.playId, "1")
        XCTAssertEqual(first.team, "COR")
        XCTAssertNil(first.time)
        XCTAssertEqual(first.scoreBy, "Smith")
        XCTAssertEqual(first.corScore, 1)
        XCTAssertEqual(first.oppScore, 0)

        let second = message.data.boxScore[1]
        XCTAssertEqual(second.playId, "2")
        XCTAssertEqual(second.period, "2nd")
        XCTAssertEqual(second.time, "12:00")
        XCTAssertEqual(second.corScore, 1)
        XCTAssertEqual(second.oppScore, 2)
        XCTAssertTrue(message.data.isLive)
        XCTAssertEqual(message.data.result, "Cornell 1, Harvard 2")
    }

    func testGameApplyingLiveUpdateTotals() throws {
        let update = try decodeSampleUpdate().data
        let original = makeGame(serverId: "abc123", date: Date.now.addingTimeInterval(3_600))
        let updated = original.applying(update)

        XCTAssertEqual(updated.id, original.id)
        XCTAssertEqual(updated.serverId, "abc123")
        XCTAssertEqual(updated.city, original.city)
        XCTAssertTrue(updated.isLive)
        XCTAssertEqual(updated.result, "Cornell 1, Harvard 2")

        XCTAssertEqual(updated.timeUpdates.map(\.cornellScore), [1, 0])
        XCTAssertEqual(updated.timeUpdates.map(\.opponentScore), [0, 2])
        XCTAssertEqual(updated.timeUpdates.reduce(0) { $0 + $1.cornellScore }, 1)
        XCTAssertEqual(updated.timeUpdates.reduce(0) { $0 + $1.opponentScore }, 2)

        XCTAssertEqual(updated.gameUpdates.count, 2)
        XCTAssertEqual(updated.gameUpdates[0].timestamp, 1)
        XCTAssertEqual(updated.gameUpdates[0].time, "N/A")
        XCTAssertEqual(updated.gameUpdates[0].cornellScore, 1)
        XCTAssertEqual(updated.gameUpdates[0].opponentScore, 0)
        XCTAssertTrue(updated.gameUpdates[0].isCornell)
        XCTAssertEqual(updated.gameUpdates[1].timestamp, 2)
        XCTAssertEqual(updated.gameUpdates[1].time, "12:00")
        XCTAssertEqual(updated.gameUpdates[1].cornellScore, 1)
        XCTAssertEqual(updated.gameUpdates[1].opponentScore, 2)
        XCTAssertFalse(updated.gameUpdates[1].isCornell)
    }

    @MainActor
    func testStoreLayersUpdateOverRefetchedGame() throws {
        let store = LiveGameStore(client: LiveScoreClient(url: try XCTUnwrap(URL(string: "http://localhost"))))
        let update = try decodeSampleUpdate().data
        store.apply(update)

        // A GraphQL refresh hands back the game without any live plays.
        let refetched = makeGame(serverId: "abc123", date: Date.now.addingTimeInterval(-600))
        let resolved = store.resolve(refetched)

        XCTAssertEqual(resolved.id, refetched.id)
        XCTAssertEqual(resolved.gameUpdates.count, 2)
        XCTAssertEqual(resolved.timeUpdates.map(\.opponentScore), [0, 2])
        XCTAssertEqual(store.update(for: refetched), update)

        let other = makeGame(serverId: "other", date: Date.now)
        XCTAssertTrue(store.resolve(other).gameUpdates.isEmpty)
        XCTAssertNil(store.update(for: other))
    }

    func testLiveStatusWindows() {
        let now = Date.now
        let justStarted = makeGame(serverId: "a", date: now.addingTimeInterval(-30 * 60))
        let startsSoon = makeGame(serverId: "b", date: now.addingTimeInterval(10 * 60))
        let longOver = makeGame(serverId: "c", date: now.addingTimeInterval(-5 * 60 * 60))
        var stillLive = longOver
        stillLive.isLive = true
        var stale = makeGame(serverId: "d", date: now.addingTimeInterval(-2 * 86_400))
        stale.isLive = true

        XCTAssertTrue(LiveStatus.isLive(justStarted, now: now))
        XCTAssertFalse(LiveStatus.isLive(startsSoon, now: now))
        XCTAssertTrue(LiveStatus.shouldSubscribe(to: startsSoon, now: now))
        XCTAssertFalse(LiveStatus.isLive(longOver, now: now))
        XCTAssertFalse(LiveStatus.shouldSubscribe(to: longOver, now: now))
        XCTAssertTrue(LiveStatus.isLive(stillLive, now: now))
        XCTAssertFalse(LiveStatus.isLive(stale, now: now))
    }

    private func decodeSampleUpdate() throws -> LiveGameUpdateMessage {
        let data = Data(sampleGameUpdate.utf8)
        let object = try JSONSerialization.jsonObject(with: data)
        return try LiveScorePayload.decode(LiveGameUpdateMessage.self, from: object)
    }

    private func makeGame(serverId: String, date: Date) -> Game {
        var game = Game(
            opponent: .defaultTeam(),
            city: "Ithaca",
            state: "NY",
            date: date,
            sport: .Basketball,
            address: "Newman Arena",
            sex: .Women,
            timeUpdates: [],
            gameUpdates: []
        )
        game.serverId = serverId
        return game
    }
}
