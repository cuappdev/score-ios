//
//  HighlightTile.swift
//  score-ios
//
//  Created by Zain Bilal on 10/3/25.
//

import SwiftUI

struct HighlightTile: View {
    var highlight: Highlight
    var isVertical: Bool
    
    var body: some View {
        switch highlight {
        case .video(let video):
            HighlightTileVideo(video: video, width:width)
        case .article(let article):
            HighlightTileArticle(article: article, width:width)
        }
    }
    
    var width: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        
        if isVertical {
            // Full screen width minus the padding
            return screenWidth - 48
        } else {
            // Divide screen width by 1.5 to show 1.5 full tiles
            return screenWidth / 1.5
        }
    }
}
