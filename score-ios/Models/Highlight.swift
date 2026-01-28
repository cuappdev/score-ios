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
    
    var title: String {
        switch self {
        case .article(let article):
            return article.title
        case .video(let video):
            return video.title
        }
    }
    
    var sport: Sport {
        switch self {
        case .article(let article):
            return article.sport
        case .video(let video):
            return video.sport
        }
    }
}

