//
//  HighlightSectionView.swift
//  score-ios
//

import SwiftUI

struct HighlightSectionView: View {
    @EnvironmentObject var viewModel: HighlightsViewModel

    let title: String
    let scope: HighlightsScope

    private var highlights: [Highlight] {
        switch scope {
        case .lastWeek:
            return viewModel.mainLastWeekHighlights
        case .recent:
            return viewModel.mainRecentHighlights
        default:
            return []
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            NavigationLink {
                DetailedHighlightsView(title: title, highlightScope: scope)
                    .environmentObject(viewModel)
            } label: {
                HStack {
                    Text(title)
                        .font(Constants.Fonts.subheader)
                        .foregroundStyle(Constants.Colors.black)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Spacer()

                    Text("\(highlights.count) \(highlights.count == 1 ? "result" : "results")")
                        .font(Constants.Fonts.body)
                        .foregroundStyle(Constants.Colors.gray_text)

                    Image(systemName: "chevron.right")
                        .font(Constants.Fonts.body)
                        .foregroundStyle(Constants.Colors.gray_text)
                }
                .padding(.top, 20)
                .padding(.horizontal, 24)
            }

            ScrollView(.horizontal) {
                LazyHStack(spacing: 24) {
                    ForEach(highlights) { highlight in
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
