//
//  LiveScoreClient.swift
//  score-ios
//
//  Socket.IO transport for per-game live scores.
//

import Foundation
import os
import SocketIO

@MainActor
final class LiveScoreClient {
    /// Decoded `game_update` and `game_info` payloads, in arrival order.
    let updates: AsyncStream<LiveGameUpdate>

    private static let logger = Logger(subsystem: "com.cornellappdev.score-ios", category: "LiveScore")

    private let url: URL
    private let continuation: AsyncStream<LiveGameUpdate>.Continuation
    private var manager: SocketManager?
    private var socket: SocketIOClient?
    /// Bumped when the socket is replaced or torn down so late callbacks from the old client are ignored.
    private var socketGeneration = 0
    private var isConnected = false
    /// The backend drops room membership on reconnect, so every tracked id is re-subscribed on connect.
    private var refCounts: [String: Int] = [:]

    nonisolated init(url: URL = ScoreEnvironment.socketURL) {
        self.url = url
        (updates, continuation) = AsyncStream.makeStream(of: LiveGameUpdate.self)
    }

    func subscribe(gameId: String) {
        let previous = refCounts[gameId, default: 0]
        refCounts[gameId] = previous + 1
        let wasConnected = isConnected
        ensureConnected()
        if previous == 0, wasConnected {
            emitSubscribeAndSnapshot(gameId)
        }
    }

    func unsubscribe(gameId: String) {
        guard let count = refCounts[gameId] else { return }
        if count > 1 {
            refCounts[gameId] = count - 1
            return
        }
        refCounts.removeValue(forKey: gameId)
        if isConnected {
            emit(.unsubscribeGame, gameId: gameId)
        }
        if refCounts.isEmpty {
            tearDownSocket()
        }
    }

    /// Drops the socket but keeps subscriptions so `resume()` can resync them.
    func suspend() {
        tearDownSocket()
    }

    func resume() {
        guard !refCounts.isEmpty else { return }
        ensureConnected()
    }

    private func ensureConnected() {
        if socket == nil {
            openSocket()
            return
        }
        if isConnected { return }
        if socket?.status == .connecting || manager?.status == .connecting { return }
        socket?.connect()
    }

    private func openSocket() {
        socketGeneration += 1
        let generation = socketGeneration
        // Starts on long-polling and upgrades when the proxy allows it; dev's nginx currently rejects the upgrade.
        let configuration: SocketIOClientConfiguration = [
            .reconnects(true),
            .reconnectWait(1),
            .reconnectWaitMax(30)
        ]
        let manager = SocketManager(socketURL: url, config: configuration)
        let socket = manager.defaultSocket
        self.manager = manager
        self.socket = socket
        bind(socket, generation: generation)
        socket.connect()
    }

    private func tearDownSocket() {
        socketGeneration += 1
        isConnected = false
        manager?.reconnects = false
        manager?.disconnect()
        socket = nil
        manager = nil
    }

    private func bind(_ socket: SocketIOClient, generation: Int) {
        socket.on(clientEvent: .connect) { [weak self] _, _ in
            Task { @MainActor in
                self?.handleConnected(generation: generation)
            }
        }
        socket.on(clientEvent: .disconnect) { [weak self] _, _ in
            Task { @MainActor in
                guard let self, self.socketGeneration == generation else { return }
                self.isConnected = false
            }
        }
        socket.on(clientEvent: .error) { [weak self] data, _ in
            Task { @MainActor in
                self?.logSocketError("Socket client error", data: data)
            }
        }
        socket.on(LiveScoreEvent.error.rawValue) { [weak self] data, _ in
            Task { @MainActor in
                self?.logSocketError("Socket error event", data: data)
            }
        }
        socket.on(LiveScoreEvent.gameUpdate.rawValue) { [weak self] data, _ in
            Task { @MainActor in
                guard let self, self.socketGeneration == generation else { return }
                self.handle(data, as: LiveGameUpdateMessage.self, event: .gameUpdate) { $0.data }
            }
        }
        socket.on(LiveScoreEvent.gameInfo.rawValue) { [weak self] data, _ in
            Task { @MainActor in
                guard let self, self.socketGeneration == generation else { return }
                self.handle(data, as: LiveGameInfoMessage.self, event: .gameInfo) { $0.game.asLiveGameUpdate() }
            }
        }
    }

    private func handleConnected(generation: Int) {
        guard socketGeneration == generation, socket != nil else { return }
        isConnected = true
        for gameId in refCounts.keys {
            emitSubscribeAndSnapshot(gameId)
        }
    }

    /// The backend sends no state on subscribe, so a snapshot is requested alongside it.
    private func emitSubscribeAndSnapshot(_ gameId: String) {
        emit(.subscribeGame, gameId: gameId)
        emit(.getGameInfo, gameId: gameId)
    }

    private func emit(_ event: LiveScoreEvent, gameId: String) {
        socket?.emit(event.rawValue, ["gameId": gameId])
    }

    private func handle<Message: Decodable>(
        _ data: [Any],
        as type: Message.Type,
        event: LiveScoreEvent,
        update: (Message) -> LiveGameUpdate
    ) {
        guard let payload = data.first else {
            logSocketError("\(event.rawValue) missing payload", data: data)
            return
        }
        do {
            let message = try LiveScorePayload.decode(type, from: payload)
            continuation.yield(update(message))
        } catch {
            logSocketError("\(event.rawValue) decode failed: \(error.localizedDescription)", data: data)
        }
    }

    private func logSocketError(_ context: String, data: [Any]) {
        let detail = data.map { String(describing: $0) }.joined(separator: " ")
        Self.logger.error("\(context, privacy: .public) \(detail, privacy: .public)")
    }
}

// MARK: - Payload decoding

enum LiveScorePayloadError: Error, LocalizedError {
    /// `JSONSerialization` cannot encode this value (a Swift object, a date, or a top-level fragment).
    case notJSONCompatible(actualType: String)

    var errorDescription: String? {
        switch self {
        case .notJSONCompatible(let actualType):
            return "Socket payload is not JSON-compatible (got \(actualType)). Expected a JSON object or array."
        }
    }
}

enum LiveScorePayload {
    /// Decodes one Socket.IO argument, not the whole argument list.
    static func decode<T: Decodable>(_ type: T.Type, from object: Any) throws -> T {
        guard JSONSerialization.isValidJSONObject(object) else {
            throw LiveScorePayloadError.notJSONCompatible(actualType: String(describing: Swift.type(of: object)))
        }
        let data: Data
        do {
            data = try JSONSerialization.data(withJSONObject: object)
        } catch {
            throw LiveScorePayloadError.notJSONCompatible(
                actualType: "\(Swift.type(of: object)) (\(error.localizedDescription))"
            )
        }
        return try JSONDecoder().decode(type, from: data)
    }
}
