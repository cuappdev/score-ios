//
//  LiveScoreEvents.swift
//  score-ios
//
//  Socket.IO event names and payloads for live scores.
//  Box score entries keep the backend's snake_case keys. GraphQL uses camelCase.
//

import Foundation

enum LiveScoreEvent: String {
    // Client to server
    case subscribeGame = "subscribe_game"
    case unsubscribeGame = "unsubscribe_game"
    case getGameInfo = "get_game_info"

    // Server to client
    case gameUpdate = "game_update"
    case gameInfo = "game_info"
    case error
}

// MARK: - game_update

/// Envelope for a `game_update` event.
/// `type` is decoded when present and is not required.
struct LiveGameUpdateMessage: Decodable {
    let type: String?
    let gameId: String
    let timestamp: String
    let data: LiveGameUpdate
}

/// Cumulative live state carried in `game_update`'s `data` object.
/// `timestamp` and `lastUpdated` stay ISO-8601 strings. `datetime.isoformat()`
/// emits fractional seconds and a numeric offset, which `JSONDecoder`'s
/// `.iso8601` strategy rejects.
struct LiveGameUpdate: Decodable, Equatable {
    let gameId: String
    let isLive: Bool
    let lastUpdated: String
    let boxScore: [LiveBoxScoreEntry]
    /// Same shape `Game.parseScoreBreakdown` already accepts.
    let scoreBreakdown: [[String?]?]?
    let result: String?

    private enum CodingKeys: String, CodingKey {
        case gameId, isLive, lastUpdated, boxScore, scoreBreakdown, result
    }
}

extension LiveGameUpdate {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.gameId = try container.decode(String.self, forKey: .gameId)
        self.isLive = try container.decode(Bool.self, forKey: .isLive)
        self.lastUpdated = try container.decode(String.self, forKey: .lastUpdated)
        // The game document stores `box_score` as null until the first play.
        self.boxScore = try container.decodeIfPresent([LiveBoxScoreEntry].self, forKey: .boxScore) ?? []
        self.scoreBreakdown = try container.decodeIfPresent([[String?]?].self, forKey: .scoreBreakdown)
        self.result = try container.decodeIfPresent(String.self, forKey: .result)
    }
}

/// One raw Mongo box-score dict. Keys are snake_case.
struct LiveBoxScoreEntry: Decodable, Equatable {
    let playId: String?
    let team: String
    let period: String
    let time: String?
    let description: String
    let scorer: String?
    let assist: String?
    let scoreBy: String?
    let corScore: Int
    let oppScore: Int

    enum CodingKeys: String, CodingKey {
        case playId = "play_id"
        case team
        case period
        case time
        case description
        case scorer
        case assist
        case scoreBy = "score_by"
        case corScore = "cor_score"
        case oppScore = "opp_score"
    }
}

extension LiveBoxScoreEntry {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        func text(_ key: CodingKeys, fallback: String) -> String {
            guard container.contains(key) else { return fallback }
            if (try? container.decodeNil(forKey: key)) == true { return fallback }
            if let value = try? container.decode(String.self, forKey: key) { return value }
            return fallback
        }

        // Scraped plays store scores as text ("7"). Live Sidearm plays store ints.
        // A missing, null, or non-numeric value becomes 0 so one partial play
        // does not reject the rest of the box score.
        func score(_ key: CodingKeys) -> Int {
            guard container.contains(key) else { return 0 }
            if (try? container.decodeNil(forKey: key)) == true { return 0 }
            if let value = try? container.decode(Int.self, forKey: key) { return value }
            if let value = try? container.decode(Double.self, forKey: key) { return Int(value) }
            if let value = try? container.decode(String.self, forKey: key) {
                if let intValue = Int(value) { return intValue }
                if let doubleValue = Double(value) { return Int(doubleValue) }
            }
            return 0
        }

        // Sidearm play ids arrive as strings or numbers.
        func playIdentifier() -> String? {
            guard container.contains(.playId) else { return nil }
            if (try? container.decodeNil(forKey: .playId)) == true { return nil }
            if let value = try? container.decode(String.self, forKey: .playId) { return value }
            if let value = try? container.decode(Int.self, forKey: .playId) { return String(value) }
            return nil
        }

        // Live Sidearm plays send the period as a number; scraped plays use "1st", "2nd".
        func periodLabel() -> String {
            if let number = try? container.decode(Int.self, forKey: .period) {
                return ordinalNumberString(for: number)
            }
            return text(.period, fallback: "")
        }

        self.playId = playIdentifier()
        self.team = text(.team, fallback: "")
        self.period = periodLabel()
        self.time = try container.decodeIfPresent(String.self, forKey: .time)
        self.description = text(.description, fallback: "N/A")
        self.scorer = try container.decodeIfPresent(String.self, forKey: .scorer)
        self.assist = try container.decodeIfPresent(String.self, forKey: .assist)
        self.scoreBy = try container.decodeIfPresent(String.self, forKey: .scoreBy)
        self.corScore = score(.corScore)
        self.oppScore = score(.oppScore)
    }
}

// MARK: - game_info

/// Envelope for a `game_info` event. `game.id` is the id used for `LiveGameUpdate.gameId`.
struct LiveGameInfoMessage: Decodable {
    let gameId: String
    let game: LiveGameSnapshot
}

/// Game document shipped inside `game_info`. Box score entries are the same raw dicts.
struct LiveGameSnapshot: Decodable {
    let id: String
    let sport: String?
    let gender: String?
    let date: String?
    let time: String?
    let city: String?
    let state: String?
    let location: String?
    let result: String?
    /// Null or absent on games that have never gone live. Decodes as `false`.
    let isLive: Bool
    /// Null or absent until the first live push. Decodes as `""`.
    let lastUpdated: String
    let boxScore: [LiveBoxScoreEntry]
    let scoreBreakdown: [[String?]?]?

    private enum CodingKeys: String, CodingKey {
        case id, sport, gender, date, time, city, state, location, result, isLive, lastUpdated, boxScore, scoreBreakdown
    }

    func asLiveGameUpdate() -> LiveGameUpdate {
        LiveGameUpdate(
            gameId: id,
            isLive: isLive,
            lastUpdated: lastUpdated,
            boxScore: boxScore,
            scoreBreakdown: scoreBreakdown,
            result: result
        )
    }
}

extension LiveGameSnapshot {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.sport = try container.decodeIfPresent(String.self, forKey: .sport)
        self.gender = try container.decodeIfPresent(String.self, forKey: .gender)
        self.date = try container.decodeIfPresent(String.self, forKey: .date)
        self.time = try container.decodeIfPresent(String.self, forKey: .time)
        self.city = try container.decodeIfPresent(String.self, forKey: .city)
        self.state = try container.decodeIfPresent(String.self, forKey: .state)
        self.location = try container.decodeIfPresent(String.self, forKey: .location)
        self.result = try container.decodeIfPresent(String.self, forKey: .result)
        if container.contains(.isLive), try container.decodeNil(forKey: .isLive) == false {
            self.isLive = try container.decode(Bool.self, forKey: .isLive)
        } else {
            self.isLive = false
        }
        if container.contains(.lastUpdated), try container.decodeNil(forKey: .lastUpdated) == false {
            self.lastUpdated = try container.decode(String.self, forKey: .lastUpdated)
        } else {
            self.lastUpdated = ""
        }
        self.boxScore = try container.decodeIfPresent([LiveBoxScoreEntry].self, forKey: .boxScore) ?? []
        self.scoreBreakdown = try container.decodeIfPresent([[String?]?].self, forKey: .scoreBreakdown)
    }
}
