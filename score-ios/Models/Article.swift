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
    var sport: Sport
    
    var formattedDate: String {
        if let date = ISO8601DateFormatter().date(from: publishedAt) {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd"
            return formatter.string(from: date)
        }
        return publishedAt
    }
}
