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
    
    private let debounceDelay: TimeInterval = 0.8
    
    private var searchResults: [Highlight] {
        let model = viewModel // avoid dynamicMemberLookup confusion
        
        switch scope {
        case .today:
            return model.detailedTodayHighlights
        case .pastThreeDays:
            return model.detailedPastThreeDaysHighlights
        default:
            return model.allHighlightsSearchResults
        }
    }

    
    var body: some View {
        VStack{
            headerView
            
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    // MARK: Results
                    if isLoading {
                        HighlightSearchLoadingView()
                    } else if searchResults.isEmpty {
                        NoHighlightView()
                            .frame(maxWidth: .infinity)
                            .frame(minHeight: UIScreen.main.bounds.height - 350)
                        // push view to the middle of the screen
                    } else {
                        HStack {
                            Text("\(searchResults.count) results")
                                .padding(.horizontal, 24)
                                .font(Constants.Fonts.subheader)
                                .foregroundStyle(Constants.Colors.gray_text)
                            
                            Spacer()
                        }
                        
                        LazyVStack(alignment: .center, spacing: 24) {
                            ForEach(searchResults) { highlight in
                                HighlightTile(highlight: highlight, isVertical: true)
                                    .padding(.horizontal, 24)
                            }
                        }
                        .padding(.top, 12)
                    }
                }
            }
            .refreshable {
                viewModel.loadHighlights()
            }
        }
        .onAppear {
            if viewModel.hasNotFetchedYet{
                viewModel.loadHighlights()
            }
            isSearchFieldFocused = true
            searchText = viewModel.searchQuery
            viewModel.filter()
        }
        .onDisappear {
            viewModel.clearSearch()
        }
    }

    private var headerView: some View {
        VStack(spacing: 0) {
            // MARK: Header
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
                        .foregroundColor(Constants.Colors.gray_text)
                    
                    TextField("Search Highlights", text: $searchText)
                        .foregroundColor(Constants.Colors.gray_text)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .onChange(of: searchText) { _, newValue in
                            debounceSearch(newValue)
                        }
                        .focused($isSearchFieldFocused)

                    if !searchText.isEmpty {
                        Button(action: { 
                            searchText = ""
                            viewModel.clearSearch()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(Constants.Colors.gray_text)
                        }
                    }
                }
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Constants.Colors.gray_border, lineWidth: 1)
                )
                
                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(Constants.Colors.gray_text)
                .padding(.horizontal, 6)
            }
            .padding()
            .padding(.horizontal, 6)
            
            SportSelectorView()
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .cornerRadius(12, corners: [.bottomLeft, .bottomRight])
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 12)
        .background(Constants.Colors.white)
    }

    
    // MARK: - Debounce
    private func debounceSearch(_ text: String) {
        debounceWorkItem?.cancel()
        isLoading = true
        
        let workItem = DispatchWorkItem {
            DispatchQueue.main.async {
                let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
                viewModel.filterBySearch(trimmed)
                viewModel.filter()
                isLoading = false
            }
        }
        
        debounceWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + debounceDelay, execute: workItem)
    }
}

// MARK: - Preview
#Preview {
    SearchViewFullScreen(title: "Search All Highlights", scope: .pastThreeDays)
        .environmentObject(HighlightsViewModel.shared)
}
