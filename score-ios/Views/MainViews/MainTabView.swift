//
//  MainTabView.swift
//  score-ios
//
//  Created by Hsia Lu wu on 11/16/24.
//

import SwiftUI

struct MainTabView: View {

    // MARK: Properties

    @Binding var selectedTab: MainTab
    @StateObject private var gamesViewModel = GamesViewModel.shared

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                switch selectedTab {
                    case .schedule:
                        UpcomingGamesView()
                            .environmentObject(gamesViewModel)
                    case .highlights:
                        HighlightView(highlights: Highlight.dummyData)
                            .environmentObject(gamesViewModel)
                    case .scores:
                        PastGamesView()
                            .environmentObject(gamesViewModel)
                }

                HStack {
                    ForEach(MainTab.allCases) { tab in
                        TabViewIcon(selectedTab: $selectedTab, tab: tab)
                            .frame(height: 45)
                            .padding(.top, 10)
                        if tab != .scores { Spacer() }
                    }
                }
                // Different paddings to balance text lengths
                .padding(.trailing, 48)
                .padding(.leading, 38)
                .padding(.bottom, 40)
                .padding(.top, 8)
                .frame(maxWidth: .infinity)
                .background(
                    Color.white
                        .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: -6)
                )

            }
            .ignoresSafeArea(edges: .bottom)
            .background(Color.white)
            .toolbar(.hidden)
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    MainTabView(selectedTab: .constant(.schedule))
}
