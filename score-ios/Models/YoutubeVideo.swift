//
//  YoutubeVideo.swift
//  score-ios
//
//  Created by Zain Bilal on 10/8/25.
//

import Foundation

struct YoutubeVideo: Identifiable {
    var id: String
    var title: String
    var description: String
    var thumbnail: String
    var b64Thumbnail: String?
    var url: String
    var publishedAt: String
    
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

// MARK: - Dummy Data
extension YoutubeVideo {
    static let dummyData: [YoutubeVideo] = [
        YoutubeVideo(
            id: "QGHb9heJAco",
            title: "Cornell Celebrates Coach Mike Schafer '86",
            description: "Cornell Celebrates Coach Mike Schafer '86 Narrated by Jeremy Schaap '91.",
            thumbnail: "https://i.ytimg.com/vi/QGHb9heJAco/hqdefault.jpg",
            b64Thumbnail: nil,
            url: "https://youtube.com/watch?v=QGHb9heJAco",
            publishedAt: "2025-10-09T00:00:00Z"
        ),
        YoutubeVideo(
            id: "ABC123def",
            title: "Cornell Basketball Highlights - Championship Game",
            description: "Watch the best moments from Cornell's championship victory.",
            thumbnail: "https://i.ytimg.com/vi/ABC123def/hqdefault.jpg",
            b64Thumbnail: nil,
            url: "https://youtube.com/watch?v=ABC123def",
            publishedAt: "2025-10-08T00:00:00Z"
        ),
        YoutubeVideo(
            id: "XYZ789ghi",
            title: "Cornell Hockey Rivalry Game Recap",
            description: "Complete recap of the intense rivalry game between Cornell and their arch-rivals.",
            thumbnail: "https://i.ytimg.com/vi/XYZ789ghi/hqdefault.jpg",
            b64Thumbnail: nil,
            url: "https://youtube.com/watch?v=XYZ789ghi",
            publishedAt: "2025-10-10T00:00:00Z"
        ),
        YoutubeVideo(
            id: "DEF456jkl",
            title: "Cornell Football Season Highlights",
            description: "Best plays and moments from Cornell's football season.",
            thumbnail: "https://i.ytimg.com/vi/DEF456jkl/hqdefault.jpg",
            b64Thumbnail: nil,
            url: "https://youtube.com/watch?v=DEF456jkl",
            publishedAt: "2025-10-11T00:00:00Z"
        )
    ]
}
