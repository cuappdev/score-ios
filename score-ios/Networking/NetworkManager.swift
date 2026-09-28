//
//  NetworkManager.swift
//  score-ios
//
//  Created by Hsia Lu wu on 11/22/24.
//
import Foundation
import Apollo
import GameAPI

class NetworkManager {

    static let shared = NetworkManager()
    let apolloClient = ApolloClient(url: ScoreEnvironment.baseURL)

    private func cachePolicy(forceNetwork: Bool) -> CachePolicy.Query.SingleResponse {
        forceNetwork ? .networkOnly : .cacheFirst
    }

    /// Unused by the new system. 
    func fetchGames(limit: Int, offset: Int, forceNetwork: Bool = false) async throws -> [GamesQuery.Data.Game] {
        let response = try await apolloClient.fetch(
            query: GamesQuery(limit: Int32(limit), offset: Int32(offset)),
            cachePolicy: cachePolicy(forceNetwork: forceNetwork)
        )
        if let games = response.data?.games?.compactMap({ $0 }) {
            return games
        }
        if let first = response.errors?.first {
            throw first
        }
        return []
    }

    /// Fetches games whose `utc_date` falls between `startDate` and `endDate` (inclusive).
    func fetchGamesByDate(
        startDate: Date,
        endDate: Date,
        forceNetwork: Bool = false
    ) async throws -> [GamesByDateQuery.Data.GamesByDate] {
        let response = try await apolloClient.fetch(
            query: GamesByDateQuery(
                startDate: Date.dateToStringFull(date: startDate),
                endDate: Date.dateToStringFull(date: endDate)
            ),
            cachePolicy: cachePolicy(forceNetwork: forceNetwork)
        )
        if let games = response.data?.gamesByDate?.compactMap({ $0 }) {
            return games
        }
        if let first = response.errors?.first {
            throw first
        }
        return []
    }

    func fetchTeamById(by id: String, forceNetwork: Bool = false) async throws -> GetTeamByIdQuery.Data.Team? {
        let response = try await apolloClient.fetch(
            query: GetTeamByIdQuery(id: id),
            cachePolicy: cachePolicy(forceNetwork: forceNetwork)
        )
        if let team = response.data?.team {
            return team
        }
        if let first = response.errors?.first {
            throw first
        }
        return nil
    }

    func fetchArticles(sportsType: String? = nil, forceNetwork: Bool = false) async throws -> [ArticlesQuery.Data.Article] {
        let response = try await apolloClient.fetch(
            query: ArticlesQuery(sportsType: sportsType.map { .some($0) } ?? .null),
            cachePolicy: cachePolicy(forceNetwork: forceNetwork)
        )
        if let articles = response.data?.articles?.compactMap({ $0 }) {
            return articles
        }
        if let first = response.errors?.first {
            throw first
        }
        return []
    }

    func fetchYoutubeVideos(forceNetwork: Bool = false) async throws -> [YoutubeVideosQuery.Data.YoutubeVideo] {
        let response = try await apolloClient.fetch(
            query: YoutubeVideosQuery(),
            cachePolicy: cachePolicy(forceNetwork: forceNetwork)
        )
        if let youtubeVideos = response.data?.youtubeVideos?.compactMap({ $0 }) {
            return youtubeVideos
        }
        if let first = response.errors?.first {
            throw first
        }
        return []
    }
}
