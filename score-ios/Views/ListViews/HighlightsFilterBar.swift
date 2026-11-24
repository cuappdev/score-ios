//
//  HighlightsFilterBar.swift
//  score-ios
//

import SwiftUI

struct HighlightsFilterBar: View {
    @ObservedObject private var viewModel = HighlightsViewModel.shared
    @ObservedObject private var authManager = AuthManager.shared

    private var filters: [HighlightsFilter] {
        var items: [HighlightsFilter] = [.all]
        if viewModel.hasFavoriteTeams {
            items.append(.favorited)
        }
        items.append(contentsOf: Sport.allCases.filter { $0 != .All }.map { .sport($0) })
        return items
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ForEach(filters) { filter in
                        Button {
                            select(filter, proxy: proxy)
                        } label: {
                            HighlightFilterChip(
                                filter: filter,
                                isSelected: viewModel.selectedFilter == filter
                            )
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel(filter.title)
                        .id(filter.id)
                    }
                }
            }
            .scrollIndicators(.hidden)
            .onAppear {
                proxy.scrollTo(viewModel.selectedFilter.id, anchor: .center)
            }
            .onChange(of: authManager.currentUser?.favoriteTeams) { _, _ in
                viewModel.filter()
            }
        }
    }

    private func select(_ filter: HighlightsFilter, proxy: ScrollViewProxy) {
        viewModel.selectFilter(filter)
        withAnimation(.easeInOut(duration: 0.2)) {
            proxy.scrollTo(filter.id, anchor: .center)
        }
    }
}

#Preview {
    HighlightsFilterBar()
        .padding()
}
