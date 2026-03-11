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
        
        Group{
            switch viewModel.dataState {
            case .idle, .loading:
                HighlightLoadingView()

            case .error:
                GameErrorView(message: "Highlights", onRetry: { viewModel.loadHighlights() })

            default:
                VStack{
                    headerView
                    
                    HighlightContentView()
                }
            }
        }
        .onAppear {
            if viewModel.dataState == .idle {
                viewModel.loadHighlights()
            }
            viewModel.clearSearch()
        }
        .onChange(of: viewModel.selectedSport) { _, _ in
            viewModel.filter()
        }
    }
    
    var headerView: some View {
        VStack {
            Text("Highlights")
                .font(Constants.Fonts.semibold24)
                .foregroundStyle(Constants.Colors.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 24)
                .padding(.horizontal, 24)
            
            SearchView(title: "Search All Highlights", scope: .all)
                .padding(.horizontal, 20)
                .padding(.top, 12)
            
            SportSelectorView()
                .padding(.horizontal, 20)
                .padding(.top, 12)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 12)
        .background(Constants.Colors.white)
    }
}

struct HighlightContentView: View {
    @EnvironmentObject var viewModel: HighlightsViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 4) {
                if viewModel.mainPastThreeDaysHighlights.isEmpty && viewModel.mainTodayHighlights.isEmpty {
                    NoHighlightView()
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: UIScreen.main.bounds.height - 350)
                        // push view to the middle of the screen
                    
                }
                
                if !viewModel.mainTodayHighlights.isEmpty {
                    HighlightSectionView(
                        title: "Today",
                        scope: .today
                    )
                }
                
                if !viewModel.mainPastThreeDaysHighlights.isEmpty {
                    HighlightSectionView(
                        title: "Past 3 Days",
                        scope: .pastThreeDays
                    )
                }
            }
        }
        .refreshable {
            viewModel.loadHighlights()
        }
    }
}

struct HighlightSectionView: View {
    @EnvironmentObject var viewModel: HighlightsViewModel
    
    let title: String
    let scope: HighlightsScope
    
    private var highlights: [Highlight] {
        switch scope {
        case .today:
            return viewModel.mainTodayHighlights
        case .pastThreeDays:
            return viewModel.mainPastThreeDaysHighlights
        default:
            return [] // Should not happen on this screen
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            NavigationLink(destination:
                DetailedHighlightsView(title: title, highlightScope: scope)
                .environmentObject(viewModel)) {
                HStack {
                    Text(title)
                        .font(Constants.Fonts.subheader)
                        .foregroundStyle(Constants.Colors.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    Text("\(highlights.count) results")
                        .font(Constants.Fonts.body)
                        .foregroundStyle(Constants.Colors.gray_text)
                    
                    Image(systemName: "chevron.right")
                        .font(Constants.Fonts.body)
                        .foregroundStyle(Constants.Colors.gray_text)
                }
                .padding(.top, 20)
                .padding(.horizontal, 24)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 24) {
                    ForEach(highlights) { highlight in
                        HighlightTile(highlight: highlight, isVertical: false)
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal, 24)
            }
        }
    }
}


// MARK: - Preview

#Preview {
    HighlightView()
        .environmentObject(HighlightsViewModel.shared)
}
