//
//  FavoritedHighlightSectionView.swift
//  score-ios
//

import SwiftUI

struct FavoritedHighlightSectionView: View {
    @EnvironmentObject private var viewModel: HighlightsViewModel
    let section: FavoritedHighlightSection

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(section.title)
                .font(Constants.Fonts.subheader)
                .foregroundStyle(Constants.Colors.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 20)
                .padding(.horizontal, 24)

            if section.highlights.isEmpty {
                HighlightSectionEmptyCard()
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
            } else {
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 24) {
                        ForEach(section.highlights) { highlight in
                            HighlightTile(
                                highlight: highlight,
                                isVertical: false,
                                isBookmarked: viewModel.isBookmarked(highlight),
                                isBookmarkPending: viewModel.isBookmarkPending(highlight),
                                onBookmarkToggle: { viewModel.toggleBookmark(for: highlight) }
                            )
                        }
                    }
                    .padding(.vertical, 8)
                    .padding(.top, 12)
                    .padding(.horizontal, 24)
                }
                .scrollIndicators(.hidden)
            }
        }
    }
}
