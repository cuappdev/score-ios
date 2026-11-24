//
//  FavoritedHighlightsContentView.swift
//  score-ios
//

import SwiftUI

struct FavoritedHighlightsContentView: View {
    @EnvironmentObject var viewModel: HighlightsViewModel

    var body: some View {
        if viewModel.favoritedSections.isEmpty {
            NoHighlightView()
                .frame(maxWidth: .infinity)
                .frame(minHeight: 400)
        } else {
            ForEach(viewModel.favoritedSections) { section in
                FavoritedHighlightSectionView(section: section)
            }
        }
    }
}
