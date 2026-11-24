//
//  HighlightContentView.swift
//  score-ios
//

import SwiftUI

struct HighlightContentView: View {
    @EnvironmentObject var viewModel: HighlightsViewModel

    private let topID = "highlights-scroll-top"

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 4) {
                    Color.clear
                        .frame(height: 1)
                        .id(topID)

                    if viewModel.selectedFilter == .favorited {
                        FavoritedHighlightsContentView()
                    } else {
                        StandardHighlightsContentView()
                    }
                }
                .padding(.bottom, MainTab.scrollClearance)
            }
            .scrollIndicators(.hidden)
            .refreshable {
                await viewModel.loadHighlights(forceNetwork: true)
            }
            .onChange(of: viewModel.selectedFilter) { _, _ in
                proxy.scrollToTopWithoutAnimation(id: topID)
            }
        }
    }
}
