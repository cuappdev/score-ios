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
    let apolloClient = ApolloClient(url: URL(string: "http://localhost:5000/graphql")!)
    
    // private(set) lazy var apollo: ApolloClient = {
//    let url = URL(string: "https://yourgraphqlendpoint.com/graphql")!
//    return ApolloClient(url: url)
//}()
    
    func fetchGames(completion: @escaping ([GamesQuery.Data.Game]?, Error?) -> Void) {
        apolloClient.fetch(query: GamesQuery()) { result in
            switch result {
            case .success(let graphQLResult):
                if let gamesData = graphQLResult.data?.games?.compactMap({ $0 }) {
                    // Print each game's information to the console
                    gamesData.forEach { game in
                        print("Game in \(game.city) on \(game.date), sport: \(game.sport), result: \(game.result ?? "N/A")")
                    }
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
    
    func filterUpcomingGames(gender: String?, sport: String?, completion: @escaping ([GamesQuery.Data.Game]?, Error?) -> Void) {
        apolloClient.fetch(query: GamesQuery()) { result in
            switch result {
            case .success(let graphQLResult):
                if let gamesData = graphQLResult.data?.games?.compactMap({ $0 }) {
                    // filter games by gender and sports
                    let filteredGames = gamesData.filter { game in
                        (gender == nil || game.gender == gender) &&
                        (sport == nil || game.sport == sport)
                    }
                    completion(filteredGames, nil)
                } else if let errors = graphQLResult.errors {
                    let errorDescription = errors.map { $0.localizedDescription }.joined(separator: "\n")
                    completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorDescription]))
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
        
    }
    
}
