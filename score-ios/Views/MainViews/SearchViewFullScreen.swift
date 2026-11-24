//
//  SearchViewFullScreen.swift
//  score-ios
//
//  Created by Zain Bilal on 10/14/25.
//

import SwiftUI

struct SearchViewFullScreen: View {
    @EnvironmentObject private var viewModel: HighlightsViewModel
    let title: String
    var scope: HighlightsScope

    @Environment(\.dismiss) private var dismiss

    @State private var searchText = ""
    @State private var debounceWorkItem: DispatchWorkItem?
    @State private var isLoading: Bool = false

    @FocusState private var isSearchFieldFocused: Bool

    private let debounceDelay: TimeInterval = 0.25
    private let topID = "search-highlights-scroll-top"

    private var searchResults: [Highlight] {
        switch scope {
        case .lastWeek:
            return viewModel.detailedLastWeekHighlights
        case .recent:
            return viewModel.detailedRecentHighlights
        case .bookmarked:
            return bookmarkedSearchResults
        case .all:
            return viewModel.allHighlightsSearchResults
        }
    }

    private var bookmarkedSearchResults: [Highlight] {
        let bookmarks = viewModel.filteredBookmarkedHighlights
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return bookmarks }
        let lowered = query.lowercased()
        return bookmarks.filter { $0.title.lowercased().contains(lowered) }
    }

    var body: some View {
        VStack {
            headerView

            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 0) {
                        Color.clear
                            .frame(height: 1)
                            .id(topID)

                        if isLoading {
                            HighlightSearchLoadingView()
                        } else if searchResults.isEmpty {
                            NoHighlightView()
                                .frame(maxWidth: .infinity)
                                .frame(minHeight: UIScreen.main.bounds.height - 350)
                        } else {
                            Text("\(searchResults.count) \(searchResults.count == 1 ? "result" : "results")")
                                .padding(.horizontal, 20)
                                .font(Constants.Fonts.subheader)
                                .foregroundStyle(Constants.Colors.gray_text)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            LazyVStack(alignment: .center, spacing: 24) {
                                ForEach(searchResults) { highlight in
                                    HighlightTile(
                                        highlight: highlight,
                                        isVertical: true,
                                        isBookmarked: viewModel.isBookmarked(highlight),
                                        isBookmarkPending: viewModel.isBookmarkPending(highlight),
                                        onBookmarkToggle: { viewModel.toggleBookmark(for: highlight) }
                                    )
                                    .padding(.horizontal, 24)
                                }
                            }
                            .padding(.top, 12)
                        }
                    }
                }
                .refreshable {
                    await viewModel.loadHighlights(forceNetwork: true)
                }
                .onChange(of: viewModel.selectedFilter) { _, _ in
                    proxy.scrollToTopWithoutAnimation(id: topID)
                }
            }
        }
        .highlightBookmarkChrome(viewModel: viewModel)
        .task {
            if viewModel.hasNotFetchedYet {
                await viewModel.loadHighlights()
            }
            isSearchFieldFocused = true
            searchText = viewModel.searchQuery
        }
        .onDisappear {
            debounceWorkItem?.cancel()
            debounceWorkItem = nil
            viewModel.clearSearch()
        }
    }

    private var headerView: some View {
        VStack(spacing: 0) {
            HStack {
                Text(title)
                    .padding(.top, 12)
                    .padding(.horizontal, 24)
                    .font(Constants.Fonts.subheader)
                    .foregroundStyle(Constants.Colors.black)

                Spacer()
            }

            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(Constants.Colors.gray_text)

                    TextField("Search Highlights", text: $searchText)
                        .foregroundStyle(Constants.Colors.gray_text)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .onChange(of: searchText) { _, newValue in
                            debounceSearch(newValue)
                        }
                        .focused($isSearchFieldFocused)

                    if !searchText.isEmpty {
                        Button {
                            searchText = ""
                            viewModel.clearSearch()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(Constants.Colors.gray_text)
                        }
                        .accessibilityLabel("Clear search")
                    }
                }
                .padding(8)
                .overlay {
                    Capsule()
                        .strokeBorder(Constants.Colors.gray_border, lineWidth: 1)
                }

                Button("Cancel") {
                    dismiss()
                }
                .foregroundStyle(Constants.Colors.primary_red)
                .padding(.horizontal, 6)
            }
            .padding()
            .padding(.horizontal, 6)

            HighlightsFilterBar()
                .padding(.horizontal, 20)
                .padding(.top, 12)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 12)
        .background(Constants.Colors.white)
    }

    private func debounceSearch(_ text: String) {
        debounceWorkItem?.cancel()
        isLoading = true

        let workItem = DispatchWorkItem {
            DispatchQueue.main.async {
                let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
                viewModel.filterBySearch(trimmed)
                isLoading = false
            }
        }

        debounceWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + debounceDelay, execute: workItem)
    }
}

#Preview {
    SearchViewFullScreen(title: "Search All Highlights", scope: .recent)
        .environmentObject(HighlightsViewModel.shared)
}
