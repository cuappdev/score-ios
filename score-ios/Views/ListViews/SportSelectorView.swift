//
//  SportSelectorView.swift
//  score-ios
//
//  Created by Mac User on 2/24/25.
//

import SwiftUI

struct SportSelectorView: View {
    @ObservedObject private var vm = GamesViewModel.shared
    @State private var scrollOffset: CGFloat = 0
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(Sport.allCases) { sport in
                        Button {
                            vm.selectedSport = sport
                            withAnimation {
                                proxy.scrollTo(sport.id, anchor: .center)
                            }
                        } label: {
                            FilterTile(sport: sport, selected: sport == vm.selectedSport)
                        }
                        .id(sport.id)
                    }
                }
                .background(GeometryReader { geometry in
                    Color.clear
                        .preference(key: ScrollOffsetKey.self, value: geometry.frame(in: .global).minX)
                })
                .onPreferenceChange(ScrollOffsetKey.self) { value in
                    vm.sportSelectorOffset = value // Save scroll position in ViewModel
                }
            }
            .onAppear {
                DispatchQueue.main.async {
                    proxy.scrollTo(vm.selectedSport.id, anchor: .center)
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
