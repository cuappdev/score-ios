//
//  DetailedHighlightView.swift
//  score-ios
//
//  Created by Zain Bilal on 10/9/25.
//
import SwiftUI

struct DetailedHighlightsView: View {
    @Environment(\.dismiss) private var dismiss
    var title: String
    var highlights: [Highlight]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                // ✅ Custom top bar
                ZStack {
                   // Centered title
                   Text(title)
                       .font(Constants.Fonts.Header.h1)
                       .foregroundStyle(Constants.Colors.black)
                   
                   // Left chevron
                   HStack {
                       Button(action: { dismiss() }) {
                           Image(systemName: "chevron.left")
                               .font(Constants.Fonts.header)
                               .foregroundStyle(Constants.Colors.black)
                       }
                       Spacer()
                   }
               }
               .padding(.horizontal, 24)
               .padding(.vertical, 8)
                
                VStack(alignment: .leading, spacing: 24) {
                    
                    SearchView()
                        .padding(.horizontal, 24)
                    
                    SportSelectorView()
                        .padding(.bottom, 6)
                    
                    // ✅ Highlights list
                    ForEach(highlights) { highlight in
                        HighlightTile(highlight: highlight, width:  345)
                            .padding(.horizontal, 24)
                    }
                }
                
               
            }
        }
        // hide default nav bar so only your custom one shows
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 200)
        }
    }
}

#Preview {
    DetailedHighlightsView(
        title: "Today",
        highlights: [
            .video(
                YoutubeVideo(
                    id: "QGHb9heJAco",
                    title: "Cornell Celebrates Coach Mike Schafer '86",
                    description: "Cornell Celebrates Coach Mike Schafer '86 Narrated by Jeremy Schaap '91.",
                    thumbnail: "https://i.ytimg.com/vi/QGHb9heJAco/hqdefault.jpg",
                    b64Thumbnail: nil,
                    url: "https://youtube.com/watch?v=QGHb9heJAco",
                    publishedAt: "2024-11-09T00:00:00Z"
                )
            ),
            .article(
                Article(
                    id: "1",
                    title: "Cornell Daily Sun Reports Historic Win",
                    summary: "Cornell’s offense shines in a big win.",
                    image: "https://snworksceo.imgix.net/cds/2f1df221-010c-4a5b-94cc-ec7a100b7aa1.sized-1000x1000.jpg?w=1000&dpr=2",
                    url: "https://cornellsun.com/article",
                    source: "Cornell Daily Sun",
                    publishedAt: "2025-10-02T00:00:00Z"
                )
            )
        ]
    )
}
