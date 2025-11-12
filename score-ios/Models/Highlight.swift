//
//  Highlight.swift
//  score-ios
//
//  Created by Zain Bilal on 10/8/25.
//

import Foundation

enum Highlight: Identifiable {
    case video(YouTubeVideo)
    case article(Article)
    
    var id: String {
        switch self {
        case .video(let video):
            return video.id
        case .article(let article):
            return article.id
        }
    }

    var publishedAt: String {
        switch self {
        case .video(let video):
            return video.publishedAt
        case .article(let article):
            return article.publishedAt
        }
    }
    
    var title: String{
        switch self{
        case .article(let article):
            return article.title
        case .video(let video):
            return video.title
        }
    }
    
    var sport: Sport{
        switch self{
        case .article(let article):
            return article.sport
        case .video(let video):
            return video.sport
        }
    }
}

// MARK: - Dummy Data
extension Highlight {
    static let dummyData: [Highlight] = [
        .video(
            YouTubeVideo(
                id: "QGHb9heJAco",
                title: "Cornell Celebrates Coach Mike Schafer '86",
                description: "Cornell Celebrates Coach Mike Schafer '86 Narrated by Jeremy Schaap '91.",
                thumbnail: "https://i.ytimg.com/vi/QGHb9heJAco/hqdefault.jpg",
                b64Thumbnail: nil,
                url: "https://youtube.com/watch?v=QGHb9heJAco",
                publishedAt: "2025-11-11T00:00:00Z",
                sport: .All
            )
        ),
        .video(
            YouTubeVideo(
                id: "ABC123def",
                title: "Cornell Basketball Highlights - Championship Game",
                description: "Watch the best moments from Cornell's championship victory.",
                thumbnail: "https://i.ytimg.com/vi/ABC123def/hqdefault.jpg",
                b64Thumbnail: nil,
                url: "https://youtube.com/watch?v=ABC123def",
                publishedAt: "2025-11-11T00:00:00Z",
                sport: .Baseball
            )
        ),
        .video(
            YouTubeVideo(
                id: "XYZ789ghi",
                title: "Cornell Hockey Rivalry Game Recap",
                description: "Complete recap of the intense rivalry game between Cornell and their arch-rivals.",
                thumbnail: "https://i.ytimg.com/vi/XYZ789ghi/hqdefault.jpg",
                b64Thumbnail: nil,
                url: "https://youtube.com/watch?v=XYZ789ghi",
                publishedAt: "2025-11-10T00:00:00Z",
                sport: .FieldHockey
            )
        )
    ]
}
