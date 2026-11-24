//
//  StandardHighlightsContentView.swift
//  score-ios
//

import SwiftUI

struct StandardHighlightsContentView: View {
    @EnvironmentObject var viewModel: HighlightsViewModel

    var body: some View {
        if viewModel.mainRecentHighlights.isEmpty && viewModel.mainLastWeekHighlights.isEmpty {
            NoHighlightView()
                .frame(maxWidth: .infinity)
                .frame(minHeight: 400)
        }

        if !viewModel.mainLastWeekHighlights.isEmpty {
            HighlightSectionView(
                title: "Most Recent",
                scope: .lastWeek
            )
        }

        if !viewModel.mainRecentHighlights.isEmpty {
            HighlightSectionView(
                title: "Past Month",
                scope: .recent
            )
        }
    }
}
