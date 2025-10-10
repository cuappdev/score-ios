//
//  HighlightTile.swift
//  score-ios
//
//  Created by Zain Bilal on 10/3/25.
//

import SwiftUI

struct HighlightTile: View {
    var highlight: Highlight
    var width: CGFloat
    
    var body: some View {
        switch highlight {
        case .video(let video):
            HighlightTileVideo(video: video, width:width)
        case .article(let article):
            HighlightTileArticle(article: article, width:width)
        }
    }
}
