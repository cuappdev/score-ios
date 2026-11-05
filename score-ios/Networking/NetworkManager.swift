//
//  NetworkManager.swift
//  score-ios
//
//  Created by Hsia Lu wu on 11/22/24.
//
import Foundation
import Apollo
import ApolloAPI
import GameAPI

class NetworkManager {

    static let shared = NetworkManager()
    let apolloClient: ApolloClient = {
        let store = ApolloStore()
        let transport = RequestChainNetworkTransport(
            urlSession: URLSession.shared,
            interceptorProvider: AuthInterceptorProvider(),
            store: store,
            endpointURL: ScoreEnvironment.baseURL
        )
        return ApolloClient(networkTransport: transport, store: store)
    }()

    private func cachePolicy(forceNetwork: Bool) -> CachePolicy.Query.SingleResponse {
        forceNetwork ? .networkOnly : .cacheFirst
    }

    /// Runs one query. A present `data` payload is returned as-is, including empty lists.
    /// A missing payload throws the first GraphQL error, or `ScoreError.networkError` when there is none.
    private func fetch<Query: GraphQLQuery, T>(
        _ query: Query,
        forceNetwork: Bool = false,
        extract: (Query.Data) -> T
    ) async throws -> T where Query.ResponseFormat == SingleResponseFormat {
        let response = try await apolloClient.fetch(
            query: query,
            cachePolicy: cachePolicy(forceNetwork: forceNetwork)
        )
        if let data = response.data {
            return extract(data)
        }
        if let first = response.errors?.first {
            throw first
        }
        throw ScoreError.networkError
    }

    /// Unused by the new system.
    func fetchGames(limit: Int, offset: Int, forceNetwork: Bool = false) async throws -> [GamesQuery.Data.Game] {
        try await fetch(
            GamesQuery(limit: Int32(limit), offset: Int32(offset)),
            forceNetwork: forceNetwork
        ) { data in
            data.games?.compactMap { $0 } ?? []
        }
    }

    /// Fetches games whose `utc_date` falls between `startDate` and `endDate` (inclusive).
    func fetchGamesByDate(
        startDate: Date,
        endDate: Date,
        forceNetwork: Bool = false
    ) async throws -> [GamesByDateQuery.Data.GamesByDate] {
        try await fetch(
            GamesByDateQuery(
                startDate: Date.dateToStringFull(date: startDate),
                endDate: Date.dateToStringFull(date: endDate)
            ),
            forceNetwork: forceNetwork
        ) { data in
            data.gamesByDate?.compactMap { $0 } ?? []
        }
    }

    func fetchTeamById(by id: String, forceNetwork: Bool = false) async throws -> GetTeamByIdQuery.Data.Team? {
        try await fetch(GetTeamByIdQuery(id: id), forceNetwork: forceNetwork) { data in
            data.team
        }
    }

    func fetchArticles(sportsType: String? = nil, forceNetwork: Bool = false) async throws -> [ArticlesQuery.Data.Article] {
        try await fetch(
            ArticlesQuery(sportsType: sportsType.map { .some($0) } ?? .null),
            forceNetwork: forceNetwork
        ) { data in
            data.articles?.compactMap { $0 } ?? []
        }
    }

    func fetchYoutubeVideos(forceNetwork: Bool = false) async throws -> [YoutubeVideosQuery.Data.YoutubeVideo] {
        try await fetch(YoutubeVideosQuery(), forceNetwork: forceNetwork) { data in
            data.youtubeVideos?.compactMap { $0 } ?? []
        }
    }
    
    // MARK: - Auth

    enum NetworkError: Error {
        case graphQL(String)
        case noData
    }

    func loginUser(idToken: String) async throws -> LoginUserMutation.Data.LoginUser {
        guard let login = try await perform(LoginUserMutation(idToken: idToken)).loginUser else {
            throw NetworkError.noData
        }
        return login
    }

    func signupUser(idToken: String) async throws -> SignupUserMutation.Data.SignupUser {
        guard let signup = try await perform(SignupUserMutation(idToken: idToken)).signupUser else {
            throw NetworkError.noData
        }
        return signup
    }

    // MARK: - Favorite Teams

    func addFavoriteTeam(sport: String, gender: String) async throws {
        _ = try await perform(AddFavoriteTeamMutation(sport: sport, gender: gender))
    }

    func removeFavoriteTeam(sport: String, gender: String) async throws {
        _ = try await perform(RemoveFavoriteTeamMutation(sport: sport, gender: gender))
    }

    // MARK: - Helpers

    private func perform<Mutation: GraphQLMutation>(
        _ mutation: Mutation
    ) async throws -> Mutation.Data where Mutation.ResponseFormat == SingleResponseFormat {
        let response = try await apolloClient.perform(mutation: mutation)
        if let errors = response.errors, !errors.isEmpty {
            throw NetworkError.graphQL(errors.map(\.localizedDescription).joined(separator: "\n"))
        }
        guard let data = response.data else { throw NetworkError.noData }
        return data
    }
}
