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
        // Filter highlights
        let todayHighlights = highlights.filter {
            if let date = Date.fullDateFormatter.date(from: $0.publishedAt) {
                return Date.isWithinPastDays(date, days: 1)
            }
            return false
        }

        let pastThreeDaysHighlights = highlights.filter {
            guard let date = Date.fullDateFormatter.date(from: $0.publishedAt) else { return false }
            return !Date.isWithinPastDays(date, days: 1) && Date.isWithinPastDays(date, days: 3)
        }

        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Highlights")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                    
                    SearchView()
                        .padding(.horizontal, 24)
                        .padding(.bottom, 12)
                    SportSelectorView()
                        .padding(.bottom, 12)
                    
                    if !todayHighlights.isEmpty {
                        HighlightSectionView(title: "Today", highlights: todayHighlights)
                    }
                    
                    if !pastThreeDaysHighlights.isEmpty {
                        HighlightSectionView(title: "Past 3 Days", highlights: pastThreeDaysHighlights)
                    }
                }
            }
        }
    }
}

struct HighlightSectionView: View {
    let title: String
    let highlights: [Highlight]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            NavigationLink(destination: DetailedHighlightsView(title: title, highlights: highlights)) {
                HStack {
                    Text(title)
                        .font(Constants.Fonts.subheader)
                        .foregroundStyle(Constants.Colors.black)
                    
                    Spacer()
                    
                    Text("\(highlights.count) results")
                        .font(Constants.Fonts.body)
                        .foregroundStyle(Constants.Colors.gray_text)
                    
                    Image(systemName: "chevron.right")
                        .font(Constants.Fonts.body)
                        .foregroundStyle(Constants.Colors.gray_text)
                }
                .padding(.horizontal, 24)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24) {
                    ForEach(highlights) { highlight in
                        HighlightTile(highlight: highlight, width: 241)
                    }
                }
                .padding(.horizontal, 24)
            }
        }
    }
}

// MARK: - Model
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

    var publishedAt: String {
        switch self {
        case .video(let video):
            return video.publishedAt
        case .article(let article):
            return article.publishedAt
        }
    }
}

extension Highlight{
    static let dummydata: [Highlight] = [
        .video(
            YoutubeVideo(
                id: "QGHb9heJAco",
                title: "Cornell Celebrates Coach Mike Schafer '86",
                description: "Cornell Celebrates Coach Mike Schafer '86 Narrated by Jeremy Schaap '91.",
                thumbnail: "https://i.ytimg.com/vi/QGHb9heJAco/hqdefault.jpg",
                b64Thumbnail: nil,
                url: "https://youtube.com/watch?v=QGHb9heJAco",
                publishedAt: "2025-10-09T00:00:00Z"
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
                publishedAt: "2025-10-010T00:00:00Z"
            )
        ),
        .video(
            YoutubeVideo(
                id: "QGHb9heJAco",
                title: "Cornell Celebrates Coach Mike Schafer '86",
                description: "Cornell Celebrates Coach Mike Schafer '86 Narrated by Jeremy Schaap '91.",
                thumbnail: "https://i.ytimg.com/vi/QGHb9heJAco/hqdefault.jpg",
                b64Thumbnail: nil,
                url: "https://youtube.com/watch?v=QGHb9heJAco",
                publishedAt: "2025-10-08T00:00:00Z"
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
                publishedAt: "2025-10-09T00:00:00Z"
            )
        ),
        .video(
            YoutubeVideo(
                id: "QGHb9heJAco",
                title: "Cornell Celebrates Coach Mike Schafer '86",
                description: "Cornell Celebrates Coach Mike Schafer '86 Narrated by Jeremy Schaap '91.",
                thumbnail: "https://i.ytimg.com/vi/QGHb9heJAco/hqdefault.jpg",
                b64Thumbnail: nil,
                url: "https://youtube.com/watch?v=QGHb9heJAco",
                publishedAt: "2025-10-010T00:00:00Z"
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
                publishedAt: "2025-10-010T00:00:00Z"
            )
        )
    ]
}

// MARK: - Preview

#Preview {
    HighlightView(highlights: Highlight.dummydata)
}
