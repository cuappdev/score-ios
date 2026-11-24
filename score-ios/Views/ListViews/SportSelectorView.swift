//
//  SportSelectorView.swift
//  score-ios
//
//  Created by Mac User on 2/24/25.
//

import SwiftUI

struct SportSelectorView: View {
    var filtersByTab = false
    var sortsByNextGame = false
    @ObservedObject private var gamesVM = GamesViewModel.shared
    @ObservedObject private var auth = AuthManager.shared

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(sports) { sport in
                        Button {
                            gamesVM.selectedSport = sport
                            withAnimation {
                                proxy.scrollTo(sport.id, anchor: .center)
                            }
                        } label: {
                            FilterTile(sport: sport, selected: sport == gamesVM.selectedSport)
                        }
                        .id(sport.id)
                    }
                }
                .animation(nil, value: sports)
                .background {
                    GeometryReader { geometry in
                        Color.clear
                            .preference(key: ScrollOffsetKey.self, value: geometry.frame(in: .global).minX)
                    }
                }
                .onPreferenceChange(ScrollOffsetKey.self) { value in
                    gamesVM.sportSelectorOffset = value
                }
            }
            .onAppear {
                proxy.scrollTo(gamesVM.selectedSport.id, anchor: .center)
            }
            .onChange(of: sports, initial: true) {
                if !sports.contains(gamesVM.selectedSport) {
                    gamesVM.selectedSport = .All
                }
            }
        }
    }

    private var sports: [Sport] {
        var list = Sport.allCases.filter { $0 != .All }
        if filtersByTab {
            if gamesVM.selectedSex == .Both {
                let favorites = auth.favoriteTeams.compactMap { Sport(normalizedValue: $0.sport) }
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
