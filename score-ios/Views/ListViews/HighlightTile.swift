//
//  HighlightTile.swift
//  score-ios
//
//  Created by Zain Bilal on 10/3/25.
//

import SwiftUI

enum Highlight: Identifiable {
    case video(YoutubeVideo)
    case article(Article)
    
    var id: String {
        switch self {
        case .video(let video):
            return video.id
        case .article(let article):
            return article.id
        }
    }
}

struct HighlightTile: View {
    var highlight: Highlight
    
    var body: some View {
        switch highlight {
        case .video(let video):
            HighlightTileVideo(video: video)
        case .article(let article):
            HighlightTileArticle(article: article)
        }
    }
}
