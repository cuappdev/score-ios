//
//  ContentView.swift
//  score-ios
//
//  Created by Daniel Chuang on 9/4/24.
//

import SwiftUI

// MARK: - Tab Enum
// Extract tab data, include three fields: title, icon, and destination
enum TabItem: Int, CaseIterable {
    case schedule
    case scores
    
    var title: String {
        switch self {
        case .schedule: return "Schedule"
        case .scores: return "Scores"
        }
    }
    
    var iconName: String {
        switch self {
        case .schedule: return "schedule"
        case .scores: return "scoreboard"
        }
    }
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .schedule:
            HomeView()
        case .scores:
            PastGameView()
        }
    }
}

// MARK: - Tab Item View
struct TabItemView: View {
    let tab: TabItem
    
    var body: some View {
        VStack {
            Image(tab.iconName)
                .renderingMode(.template)
            Text(tab.title)
        }
    }
}

// MARK: - Content View
struct ContentView: View {
    @State private var selectedTab: TabItem = .schedule
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                tab.destination
                    .tabItem {
                        TabItemView(tab: tab)
                    }
                    .tag(tab)
            }
        }
        .background(Color.white)
        .accentColor(Constants.Colors.primary_red) // Red highlight
    }
}

#Preview {
    ContentView()
}
