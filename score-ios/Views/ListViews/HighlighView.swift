//
//  HighlightView.swift
//  score-ios
//
//  Created by Zain Bilal on 10/4/25.
//

import SwiftUI

struct HighlightView: View {
    var highlights: [Highlight]

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                
                // Section title
                Text("Highlights")
                    .font(Constants.Fonts.Header.h1)
                    .foregroundStyle(Constants.Colors.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                
                SearchView()
                    .padding(.horizontal, 24)

                
                SportSelectorView()
                    .padding(.bottom, 6)

                
                // Today's Highlights
                HStack(){
                    Text("Today")
                        .font(Constants.Fonts.subheader)
                        .foregroundStyle(Constants.Colors.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 24)
                    
                    Spacer()
                    
                    Text("\(highlights.count) results")
                        .font(Constants.Fonts.body)
                        .foregroundStyle(Constants.Colors.gray_text)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    Image(systemName: "chevron.right")
                        .font(Constants.Fonts.body)
                        .padding(.trailing, 24)
                        .foregroundStyle(Constants.Colors.gray_text)
                }
               

                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 24) {
                        ForEach(highlights) { highlight in
                            HighlightTile(highlight: highlight)
                        }
                    }
                    .padding(.horizontal, 24)

                }
                .padding(.bottom, 12)

                
                
                // Past three days
                HStack(){
                    Text("Past 3 days")
                        .font(Constants.Fonts.subheader)
                        .foregroundStyle(Constants.Colors.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 24)
                    
                    Spacer()
                    
                    Text("\(highlights.count) results")
                        .font(Constants.Fonts.body)
                        .foregroundStyle(Constants.Colors.gray_text)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    Image(systemName: "chevron.right")
                        .font(Constants.Fonts.body)
                        .padding(.trailing, 24)
                        .foregroundStyle(Constants.Colors.gray_text)
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 24) {
                        ForEach(highlights) { highlight in
                            HighlightTile(highlight: highlight)
                        }
                    }
                    .padding(.horizontal, 24)
                }

            }
            .safeAreaInset(edge: .bottom, content: {
                Color.clear.frame(height: 200)
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        
    }
}

// MARK: - Preview

#Preview {
    HighlightView(highlights: [
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
    ])
}
