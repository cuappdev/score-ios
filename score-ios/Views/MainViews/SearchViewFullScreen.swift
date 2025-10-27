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
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var searchText = ""
    @State private var debounceWorkItem: DispatchWorkItem?
    
    @FocusState private var isSearchFieldFocused: Bool
    
    private let debounceDelay: TimeInterval = 0.8
    
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
                VStack {
                    Spacer()
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.2)
                    
                    Spacer()
                }
            } else if viewModel.filteredHighlights.isEmpty {
                VStack {
                   NoHighlightView()
                }
            } else {
                ScrollView {
                    HStack {
                        Text("\(viewModel.filteredCount) results")
                            .padding(.top, 12)
                            .padding(.horizontal, 24)
                            .font(Constants.Fonts.subheader)
                            .foregroundStyle(Constants.Colors.gray_text)
                        
                        Spacer()
                    }
                    
                    LazyVStack(alignment: .leading, spacing: 24) {
                        ForEach(viewModel.filteredHighlights) { highlight in
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
        }
    }
    
    // MARK: - Debounce
    private func debounceSearch(_ text: String) {
        debounceWorkItem?.cancel()
        
        let workItem = DispatchWorkItem {
            DispatchQueue.main.async {
                let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
                viewModel.filterBySearch(trimmed)
            }
        }
        
        debounceWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + debounceDelay, execute: workItem)
    }
}

// MARK: - Preview
#Preview {
    SearchViewFullScreen(title: "Search All Highlights")
        .environmentObject(HighlightsViewModel.shared)
}
