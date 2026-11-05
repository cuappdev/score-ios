//
//  AnalyticsManager.swift
//  score-ios
//
//  Created by Zain Bilal on 10/7/26.
//

import FirebaseAnalytics
import SwiftUI

enum AnalyticsEvent: String {
    // Names: <= 40 chars, letters/digits/underscores, must start with a letter.
    case ticketingLinkClicked = "ticketing_link_clicked"
    case addToCalendarTapped = "add_to_calendar"
}

enum AnalyticsScreen: String {
    case schedule = "Schedule"
    case scores = "Scores"
    case highlights = "Highlights"
}

enum AnalyticsManager {
    static func log(_ event: AnalyticsEvent) {
        Analytics.logEvent(event.rawValue, parameters: nil)
    }
}

extension View {
    /// Logs a `screen_view` event each time this view appears.
    func trackScreen(_ screen: AnalyticsScreen) -> some View {
        analyticsScreen(name: screen.rawValue)
    }
}
