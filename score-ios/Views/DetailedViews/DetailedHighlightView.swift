//
//  DetailedHighlightView.swift
//  score-ios
//
//  Created by Zain Bilal on 10/9/25.
//

import SwiftUI

struct DetailedHighlightsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: HighlightsViewModel

    var title: String
    var highlightScope: HighlightsScope

    private let topID = "detailed-highlights-scroll-top"

    var body: some View {
        VStack {
            headerView

            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 16) {
                        Color.clear
                            .frame(height: 1)
                            .id(topID)

                        if highlightsForScope.isEmpty {
                            NoHighlightView()
                                .frame(maxWidth: .infinity)
                                .frame(minHeight: UIScreen.main.bounds.height - 350)
                        } else {
                            LazyVStack(alignment: .center) {
                                ForEach(highlightsForScope, id: \.id) { highlight in
                                    HighlightTile(
                                        highlight: highlight,
                                        isVertical: true,
                                        isBookmarked: viewModel.isBookmarked(highlight),
                                        isBookmarkPending: viewModel.isBookmarkPending(highlight),
                                        onBookmarkToggle: { viewModel.toggleBookmark(for: highlight) }
                                    )
                                    .padding(.horizontal, 24)
                                    .padding(.top, 12)
                                }
                            }
                        }
                    }
                }
                .background(Constants.Colors.white.ignoresSafeArea())
                .refreshable {
                    await viewModel.loadHighlights(forceNetwork: true)
                }
                .safeAreaInset(edge: .bottom) {
                    Color.clear.frame(height: 32)
                }
                .onChange(of: viewModel.selectedFilter) { _, _ in
                    proxy.scrollToTopWithoutAnimation(id: topID)
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
        }
        .environmentObject(viewModel)
        .task {
            if viewModel.hasNotFetchedYet {
                await viewModel.loadHighlights()
            }
            viewModel.clearSearch()
        }
    }

    private var highlightsForScope: [Highlight] {
        switch highlightScope {
        case .lastWeek:
            return viewModel.detailedLastWeekHighlights
        case .recent:
            return viewModel.detailedRecentHighlights
        case .bookmarked:
            let teams = AuthManager.shared.currentUser?.favoriteTeams ?? []
            return viewModel.bookmarkedHighlights.filter {
                viewModel.selectedFilter.matches($0, favoriteTeams: teams)
            }
        case .all:
            return viewModel.allHighlights
        }
    }

    private var headerView: some View {
        VStack(alignment: .leading, spacing: 16) {
            ZStack {
                Text(title)
                    .font(Constants.Fonts.header)
                    .foregroundStyle(Constants.Colors.black)

                HStack {
                    BackButton { dismiss() }
                    Spacer()
                    HighlightsSearchButton(title: "Search \(title)", scope: highlightScope)
                }
            }
            .padding(.top, 24)
            .padding(.horizontal, 24)

            HighlightsFilterBar()
                .padding(.horizontal, 24)
                .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 12)
        .background(Constants.Colors.white)
    }
}

#Preview {
    DetailedHighlightsView(
        title: "Most Recent",
        highlightScope: .lastWeek
    )
    .environmentObject(HighlightsViewModel.shared)
}
