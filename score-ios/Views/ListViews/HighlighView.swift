//
//  HighlighView.swift
//  score-ios
//
//  Created by Zain Bilal on 10/4/25.
//

import SwiftUI

struct HighlightView: View {
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                Text("Highlights")
                    .font(Constants.Fonts.semibold24)
                    .foregroundStyle(Constants.Colors.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                SportSelectorView()
                   
                
                // Today's Highlights
                if 1==1 {
                    Text("Today")
                        .font(Constants.Fonts.medium18)
                        .foregroundStyle(Constants.Colors.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 24) {
                            ForEach(1...3, id: \.self) {_ in
                                HighlightTile(video: YoutubeVideo(
                                    id: "QGHb9heJAco",
                                    title: "Cornell Celebrates Coach Mike Schafer '86",
                                    description: "Cornell Celebrates Coach Mike Schafer '86 Narrated by Jeremy Schaap '91.",
                                    thumbnail: "https://i.ytimg.com/vi/QGHb9heJAco/hqdefault.jpg",
                                    b64Thumbnail: nil,
                                    url: "https://youtube.com/watch?v=QGHb9heJAco",
                                    publishedAt: "2024-11-09T00:00:00Z"
                                ))
                            }
                        }.padding(.horizontal)
                    }
                }
                
                //past three days
                if 1==1 {
                    Text("Past 3 days")
                        .font(Constants.Fonts.medium18)
                        .foregroundStyle(Constants.Colors.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                            
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 24) {
                            ForEach(1...3, id: \.self) {_ in
                                HighlightTile(video: YoutubeVideo(
                                    id: "QGHb9heJAco",
                                    title: "Cornell Celebrates Coach Mike Schafer '86",
                                    description: "Cornell Celebrates Coach Mike Schafer '86 Narrated by Jeremy Schaap '91.",
                                    thumbnail: "https://i.ytimg.com/vi/QGHb9heJAco/hqdefault.jpg",
                                    b64Thumbnail: nil,
                                    url: "https://youtube.com/watch?v=QGHb9heJAco",
                                    publishedAt: "2024-11-09T00:00:00Z"
                                    )
                                )
                            }
                        }.padding(.horizontal)
                    }
                }
            }
        }
    }
}

// MARK: - Preview
struct HighlightView_Previews: PreviewProvider {
    static var previews: some View {
        HighlightView()
    }
}
