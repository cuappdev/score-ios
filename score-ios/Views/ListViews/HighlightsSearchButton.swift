//
//  HighlightsSearchButton.swift
//  score-ios
//

import SwiftUI

struct HighlightsSearchButton: View {
    @EnvironmentObject private var viewModel: HighlightsViewModel
    @State private var showSearch = false

    let title: String
    let scope: HighlightsScope

    var body: some View {
        Button("Search highlights", systemImage: "magnifyingglass") {
            showSearch = true
        }
        .labelStyle(.iconOnly)
        .font(.system(size: 18, weight: .medium))
        .foregroundStyle(Constants.Colors.black)
        .frame(minWidth: 44, minHeight: 44)
        .contentShape(Rectangle())
        .fullScreenCover(isPresented: $showSearch) {
            SearchViewFullScreen(title: title, scope: scope)
                .environmentObject(viewModel)
                .onAppear {
                    viewModel.clearSearch()
                }
        }
    }
}

#Preview {
    HighlightsSearchButton(title: "Search All Highlights", scope: .all)
        .environmentObject(HighlightsViewModel.shared)
}
