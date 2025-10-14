//
//  Article.swift
//  score-ios
//
//  Created by Zain Bilal on 10/8/25.
//

import Foundation

struct Article: Identifiable {
    var id: String
    var title: String
    var summary: String
    var image: String
    var url: String
    var source: String
    var publishedAt: String
    
    var formattedDate: String {
        if let date = ISO8601DateFormatter().date(from: publishedAt) {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd"
            return formatter.string(from: date)
        }
        return publishedAt
    }
}

// MARK: - Dummy Data
extension Article {
    static let dummyData: [Article] = [
        Article(
            id: "1",
            title: "Cornell Upsets Rival in Thrilling Overtime Victory",
            summary: "Cornell's offense exploded late in the fourth quarter to secure a dramatic win.",
            image: "https://snworksceo.imgix.net/cds/2f1df221-010c-4a5b-94cc-ec7a100b7aa1.sized-1000x1000.jpg?w=1000&dpr=2",
            url: "https://cornellbigred.com/news/2025/10/08/article",
            source: "Cornell Daily Sun",
            publishedAt: "2025-10-08T00:00:00Z"
        ),
        Article(
            id: "2",
            title: "Cornell Daily Sun Reports Historic Win",
            summary: "Cornell's offense shines in a big win.",
            image: "https://snworksceo.imgix.net/cds/2f1df221-010c-4a5b-94cc-ec7a100b7aa1.sized-1000x1000.jpg?w=1000&dpr=2",
            url: "https://cornellsun.com/article",
            source: "Cornell Daily Sun",
            publishedAt: "2025-10-09T00:00:00Z"
        ),
        Article(
            id: "3",
            title: "Big Red Basketball Team Advances to Championship",
            summary: "Cornell basketball team secures spot in the championship game with dominant performance.",
            image: "https://snworksceo.imgix.net/cds/2f1df221-010c-4a5b-94cc-ec7a100b7aa1.sized-1000x1000.jpg?w=1000&dpr=2",
            url: "https://cornellsun.com/basketball-championship",
            source: "Cornell Daily Sun",
            publishedAt: "2025-10-10T00:00:00Z"
        ),
        Article(
            id: "4",
            title: "Hockey Team Prepares for Rivalry Game",
            summary: "Cornell hockey team gears up for the highly anticipated rivalry matchup.",
            image: "https://snworksceo.imgix.net/cds/2f1df221-010c-4a5b-94cc-ec7a100b7aa1.sized-1000x1000.jpg?w=1000&dpr=2",
            url: "https://cornellsun.com/hockey-rivalry",
            source: "Cornell Daily Sun",
            publishedAt: "2025-10-11T00:00:00Z"
        )
    ]
}
