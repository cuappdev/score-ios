//
//  Highlight.swift
//  score-ios
//
//  Created by Zain Bilal on 10/8/25.
//

import Foundation

enum Highlight: Identifiable, Equatable {
    case video(YouTubeVideo)
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

    var title: String {
        switch self {
        case .article(let article):
            return article.title
        case .video(let video):
            return video.title
        }
    }

    var sport: Sport {
        switch self {
        case .article(let article):
            return article.sport
        case .video(let video):
            return video.sport
        }
    }

    /// Videos with a real server id only — synthetic `video:…` fallbacks are not API-valid.
    var isBookmarkable: Bool {
        if case .video(let video) = self { return video.hasServerId }
        return false
    }

    /// Best-effort gender from title when the API does not provide one.
    var inferredGender: Sex? {
        let lowered = title.lowercased()
        if lowered.range(of: #"\b(women|womens|women's)\b"#, options: .regularExpression) != nil {
            return .Women
        }
        if lowered.range(of: #"\b(men|mens|men's)\b"#, options: .regularExpression) != nil {
            return .Men
        }
        return nil
    }

    func matchesFavoriteTeam(_ team: FavoriteTeam) -> Bool {
        guard let sport = Sport(normalizedValue: team.sport), self.sport == sport else {
            return false
        }
        guard let inferred = inferredGender else { return true }
        return inferred == team.sex
    }
}
