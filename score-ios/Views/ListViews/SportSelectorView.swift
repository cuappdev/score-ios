//
//  SportSelectorView.swift
//  score-ios
//
//  Created by Mac User on 2/24/25.
//

import SwiftUI

struct SportSelectorView: View {
    var showsFavoritesOnly = false
    var sortsByNextGame = false
    @ObservedObject private var highlightsVM = HighlightsViewModel.shared
    @ObservedObject private var gamesVM = GamesViewModel.shared
    @ObservedObject private var auth = AuthManager.shared
    @State private var scrollOffset: CGFloat = 0
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(sports) { sport in
                        Button {
                            highlightsVM.selectedSport = sport
                            gamesVM.selectedSport = sport
                            withAnimation {
                                proxy.scrollTo(sport.id, anchor: .center)
                            }
                        } label: {
                            FilterTile(sport: sport, selected: sport == highlightsVM.selectedSport)
                        }
                        .id(sport.id)
                    }
                }
                .animation(nil, value: sports)
                .background(GeometryReader { geometry in
                    Color.clear
                        .preference(key: ScrollOffsetKey.self, value: geometry.frame(in: .global).minX)
                })
                .onPreferenceChange(ScrollOffsetKey.self) { value in
                    highlightsVM.sportSelectorOffset = value // Save scroll position in ViewModel
                }
            }
            .onAppear {
                DispatchQueue.main.async {
                    proxy.scrollTo(highlightsVM.selectedSport.id, anchor: .center)
                }
            }
            .onChange(of: sports) {
                if !sports.contains(gamesVM.selectedSport) {
                    highlightsVM.selectedSport = .All
                    gamesVM.selectedSport = .All
                }
            }
        }
    }
    private var sports: [Sport] {
        let favorites = auth.favoriteTeams.compactMap { Sport(normalizedValue: $0.sport) }
        var list = Sport.allCases.filter { $0 != .All }
        if showsFavoritesOnly {
            if gamesVM.selectedSex == .Both {
                if !favorites.isEmpty {
                    list = list.filter { favorites.contains($0) }
                }
            } else {
                list = list.filter { $0.genders.contains(gamesVM.selectedSex) }
            }
        }
        if sortsByNextGame {
            list = gamesVM.sortedByNextGame(list)
        }
        return [.All] + list
    }
}

// Custom Preference Key to track scroll position
struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
