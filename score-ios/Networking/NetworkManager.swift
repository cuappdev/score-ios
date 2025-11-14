//
//  NetworkManager.swift
//  score-ios
//
//  Created by Hsia Lu wu on 11/22/24.
//
import Foundation
import SwiftUI
import Apollo
import GameAPI

class NetworkManager {

    static let shared = NetworkManager()
    let apolloClient = ApolloClient(url: ScoreEnvironment.baseURL)

    func fetchGames(limit: Int, offset: Int, completion: @escaping ([GamesQuery.Data.Game]?, Error?) -> Void) {
        apolloClient.fetch(query: GamesQuery(limit: limit, offset: offset)) { result in
            switch result {
            case .success(let graphQLResult):
                if let gamesData = graphQLResult.data?.games?.compactMap({ $0 }) {
                    completion(gamesData, nil)
                } else if let errors = graphQLResult.errors {
                    let errorDescription = errors.map { $0.localizedDescription }.joined(separator: "\n")
                    completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorDescription]))
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }

    func fetchTeamById(by id: String, completion: @escaping (GetTeamByIdQuery.Data.Team?, Error?) -> Void) {
        let query = GetTeamByIdQuery(id: id)

        apolloClient.fetch(query: query) { result in
            switch result {
            case .success(let graphQLResult):
                if let team = graphQLResult.data?.team {
                    completion(team, nil)
                } else if let errors = graphQLResult.errors {
                    completion(nil, errors.first!)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func fetchArticles(completion: @escaping ([ArticlesQuery.Data.Article]?, Error?) -> Void) {
        let query = ArticlesQuery(sportsType: nil)
        
        apolloClient.fetch(query: query) { result in
            switch result {
            case .success(let graphQLResult):
                if let articlesData = graphQLResult.data?.articles?.compactMap({ $0 }) {
                    completion(articlesData, nil)
                } else if let errors = graphQLResult.errors {
                    let errorDescription = errors.map { $0.localizedDescription }.joined(separator: "\n")
                    completion(nil, NSError(domain: "GraphQL", code: 0, userInfo: [NSLocalizedDescriptionKey: errorDescription]))
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func fetchYouTubeVideos(completion: @escaping ([YoutubeVideosQuery.Data.YoutubeVideo]?, Error?) -> Void) {
        let query = YoutubeVideosQuery()
        
        apolloClient.fetch(query: query) { result in
            switch result {
            case .success(let graphQLResult):
                if let youTubeVideoData = graphQLResult.data?.youtubeVideos?.compactMap({ $0 }) {
                    completion(youTubeVideoData, nil)
                } else if let errors = graphQLResult.errors {
                    let errorDescription = errors.map { $0.localizedDescription }.joined(separator: "\n")
                    completion(nil, NSError(domain: "GraphQL", code: 0, userInfo: [NSLocalizedDescriptionKey: errorDescription]))
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
