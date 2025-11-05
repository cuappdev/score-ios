//
//  YoutubeVideo.swift
//  score-ios
//
//  Created by Zain Bilal on 10/8/25.
//

import Foundation

struct YouTubeVideo: Identifiable {
    var id: String
    var title: String
    var description: String
    var thumbnail: String
    var b64Thumbnail: String?
    var url: String
    var publishedAt: String
    var sport: Sport
    
    // Format publishedAt -> MM/dd or similar
    var formattedDate: String {
        if let date = ISO8601DateFormatter().date(from: publishedAt) {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd"
            return formatter.string(from: date)
        }
        return publishedAt
    }
}
