//
//  YoutubeVideo.swift
//  score-ios
//
//  Created by Zain Bilal on 10/8/25.
//

import Foundation
import GameAPI

struct YouTubeVideo: Identifiable, Equatable {
    var id: String
    /// False when `id` is a local fallback — bookmark API needs a real server id.
    var hasServerId: Bool
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
        self.init(
            id: gqlYouTubeVideo.id,
            title: gqlYouTubeVideo.title,
            description: gqlYouTubeVideo.description,
            thumbnail: gqlYouTubeVideo.thumbnail,
            b64Thumbnail: gqlYouTubeVideo.b64Thumbnail,
            url: gqlYouTubeVideo.url,
            publishedAt: gqlYouTubeVideo.publishedAt,
            sportsType: gqlYouTubeVideo.sportsType,
            duration: gqlYouTubeVideo.duration
        )
    }

    init(from gqlYouTubeVideo: MyBookmarkedHighlightsQuery.Data.MyBookmarkedHighlight) {
        self.init(
            id: gqlYouTubeVideo.id,
            title: gqlYouTubeVideo.title,
            description: gqlYouTubeVideo.description,
            thumbnail: gqlYouTubeVideo.thumbnail,
            b64Thumbnail: gqlYouTubeVideo.b64Thumbnail,
            url: gqlYouTubeVideo.url,
            publishedAt: gqlYouTubeVideo.publishedAt,
            sportsType: gqlYouTubeVideo.sportsType,
            duration: gqlYouTubeVideo.duration
        )
    }

    private init(
        id: String?,
        title: String,
        description: String,
        thumbnail: String,
        b64Thumbnail: String?,
        url: String,
        publishedAt: String,
        sportsType: String?,
        duration: String?
    ) {
        self.hasServerId = id != nil
        self.id = id ?? "video:\(url)"
        self.title = title
        self.description = description
        self.thumbnail = thumbnail
        self.b64Thumbnail = b64Thumbnail
        self.url = url
        self.publishedAt = publishedAt
        self.sport = Sport(normalizedValue: sportsType ?? "All") ?? .All
        self.duration = duration
    }
}
