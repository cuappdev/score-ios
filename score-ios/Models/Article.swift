//
//  Article.swift
//  score-ios
//
//  Created by Zain Bilal on 10/8/25.
//

import Foundation
import GameAPI

struct Article: Identifiable {
    var id: String
    var title: String
    var image: String
    var url: String
    var publishedAt: String
    var sport: Sport
    
    var formattedDate: String {
        if let date = ISO8601DateFormatter().date(from: publishedAt) {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd"
            return formatter.string(from: date)
        }
        return publishedAt
    }
    
    init(from gqlArticle: ArticlesQuery.Data.Article) {
        self.id = gqlArticle.id ?? UUID().uuidString
        self.image = gqlArticle.image ?? ""
        self.title = gqlArticle.title
        self.url = gqlArticle.url
        self.publishedAt = gqlArticle.publishedAt
        self.sport = Sport(normalizedValue: gqlArticle.sportsType) ?? .All
    }
}
