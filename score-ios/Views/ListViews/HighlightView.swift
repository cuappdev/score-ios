//
//  HighlightView.swift
//  score-ios
//
//  Created by Zain Bilal on 10/4/25.
//

import SwiftUI

struct HighlightView: View {
    @EnvironmentObject var viewModel: HighlightsViewModel

    var body: some View {
        Group {
            switch viewModel.dataState {
            case .idle, .loading:
                HighlightLoadingView()

            case .error:
                HighlightErrorView()

            case .success:
                VStack(spacing: 0) {
                    headerView
                    HighlightContentView()
                }
            }
        }
        .task {
            if viewModel.dataState == .idle {
                await viewModel.loadHighlights()
            }
            viewModel.clearSearch()
            viewModel.syncBookmarksFromAuth()
        }
        .trackScreen(.highlights)
    }

    private var headerView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center) {
                Text("Highlights")
                    .font(Constants.Fonts.semibold24)
                    .foregroundStyle(Constants.Colors.black)

                Spacer()

                HighlightsSearchButton(title: "Search All Highlights", scope: .all)
            }
            .padding(.top, 24)
            .padding(.horizontal, 24)

            HighlightsFilterBar()
                .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 12)
        .background(Constants.Colors.white)
    }
}

#Preview {
    NavigationStack {
        HighlightView()
            .environmentObject(HighlightsViewModel.shared)
    }
}
