//
//  YoutubeVideo.swift
//  score-ios
//
//  Created by Zain Bilal on 10/8/25.
//

import Foundation
import GameAPI

struct YouTubeVideo: Identifiable {
    var id: String
    var title: String
    var description: String
    var thumbnail: String
    var b64Thumbnail: String?
    var url: String
    var publishedAt: String
    var sport: Sport
    var duration: String?
    
    // Format publishedAt -> MM/dd or similar
    var formattedDate: String {
        if let date = ISO8601DateFormatter().date(from: publishedAt) {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd"
            return formatter.string(from: date)
        }
        return publishedAt
    }
    
    init(from gqlYouTubeVideo: YoutubeVideosQuery.Data.YoutubeVideo) {
        self.id = gqlYouTubeVideo.id ?? UUID().uuidString
        self.title = gqlYouTubeVideo.title
        self.description = gqlYouTubeVideo.description
        self.thumbnail = gqlYouTubeVideo.thumbnail
        self.b64Thumbnail = gqlYouTubeVideo.b64Thumbnail
        self.url = gqlYouTubeVideo.url
        self.publishedAt = gqlYouTubeVideo.publishedAt
        self.sport = .All
        self.duration = gqlYouTubeVideo.duration
        print(publishedAt)
    }
}
