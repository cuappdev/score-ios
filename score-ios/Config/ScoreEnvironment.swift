//
//  ScoreEnvironment.swift
//  score-ios
//
//  Created by Daniel Chuang on 3/2/25.
//

import Foundation

/// Data from Info.plist stored as environment variables.
enum ScoreEnvironment {

    /// Keys from Info.plist.
    enum Keys {
#if DEBUG
        static let baseURL: String = "SCORE_DEV_URL"
#else
        static let baseURL: String = "SCORE_PROD_URL"
#endif
    }

    /// A dictionary storing key-value pairs from Info.plist.
    private static let infoDict: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Info.plist not found")
        }
        return dict
    }()

    /**
     The base URL of Score's backend server.

     * If the scheme is set to DEBUG, the development server URL is used.
     * If the scheme is set to RELEASE, the production server URL is used.
     */
    static let baseURL: URL = {
        guard let baseURLString = ScoreEnvironment.infoDict[Keys.baseURL] as? String,
              let baseURL = URL(string: baseURLString) else {
#if DEBUG
            fatalError("SCORE_DEV_URL not found in Info.plist")
#else
            fatalError("SCORE_PROD_URL not found in Info.plist")
#endif
        }
        return baseURL
    }()

    
}
