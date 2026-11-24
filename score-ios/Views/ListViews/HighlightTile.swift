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
    var isBookmarked: Bool = false
    var isBookmarkPending: Bool = false
    var onBookmarkToggle: (() -> Void)?

    var body: some View {
        switch highlight {
        case .video(let video):
            HighlightTileVideo(
                video: video,
                width: width,
                isBookmarked: isBookmarked,
                isBookmarkPending: isBookmarkPending,
                onBookmarkToggle: { onBookmarkToggle?() }
            )
        case .article(let article):
            HighlightTileArticle(article: article, width: width)
        }
    }

    var width: CGFloat {
        let screenWidth = UIScreen.main.bounds.width

        if isVertical {
            return screenWidth - 48
        } else {
            return screenWidth / 1.5
        }
    }
}
