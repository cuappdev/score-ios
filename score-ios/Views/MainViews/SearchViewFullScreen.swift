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
    
    @FocusState private var isSearchFieldFocused: Bool
    
    private let debounceDelay: TimeInterval = 0.8
    
    private var searchResults: [Highlight] {
        let model = viewModel // avoid dynamicMemberLookup confusion
        
        switch scope {
        case .today:
            return model.mainTodayHighlights
        case .pastThreeDays:
            return model.mainPastThreeDaysHighlights
        default:
            return model.allHighlights
        }
    }

    
    var body: some View {
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
            
            // MARK: Results
            if searchText.isEmpty {
                Spacer()
            } else if viewModel.isLoading {
                Spacer()
            } else if searchResults.isEmpty {
                VStack {
                    NoHighlightView()
                }
            } else {
                ScrollView {
                    HStack {
                        Text("\(searchResults.count) results")
                            .padding(.top, 12)
                        
                        Spacer()
                    }
                    
                    LazyVStack(alignment: .leading, spacing: 24) {
                        ForEach(searchResults) { highlight in
                            HighlightTile(highlight: highlight, width: 360)
                                .padding(.horizontal, 24)
                        }
                    }
                }
                .transition(.opacity)
            }
        }
        .onAppear {
            isSearchFieldFocused = true
            searchText = viewModel.searchQuery
            viewModel.filter()
        }
        .onDisappear {
            viewModel.clearSearch()
        }
    }

    
    // MARK: - Debounce
    private func debounceSearch(_ text: String) {
        debounceWorkItem?.cancel()
        
        let workItem = DispatchWorkItem {
            DispatchQueue.main.async {
                let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
                viewModel.filterBySearch(trimmed)
                viewModel.filter()
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
