//
//  SportSelectorView.swift
//  score-ios
//
//  Created by Mac User on 2/24/25.
//

import SwiftUI

struct SportSelectorView: View {
    @ObservedObject private var highlightsVM = HighlightsViewModel.shared
    @ObservedObject private var gamesVM = GamesViewModel.shared
    @State private var scrollOffset: CGFloat = 0
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(gamesVM.orderSportsByUpcoming(sports: Sport.allCases)) { sport in
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
        }
    }
}

// Custom Preference Key to track scroll position
struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
