//
//  NetworkEnv.swift
//  score-ios
//
//  Created by Daniel Chuang on 2/12/25.
//

let network_mode = NetworkEnv.local

enum NetworkEnv {
    case local
    case deployment
    
    var endpoint: String {
        switch self {
        case .local:
            return "http://localhost:5000/graphql"
        case .deployment:
            return "https://score-dev.cornellappdev.com/graphql"
        }
    }
}
