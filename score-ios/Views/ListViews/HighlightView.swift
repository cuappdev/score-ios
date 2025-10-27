//
//  HighlightView.swift
//  score-ios
//
//  Created by Zain Bilal on 10/4/25.
//

import SwiftUI

struct HighlightView: View {
    @ObservedObject private var viewModel = HighlightsViewModel.shared
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Highlights")
                        .font(Constants.Fonts.semibold24)
                        .foregroundStyle(Constants.Colors.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 24)
                        .padding(.horizontal, 24)
                        
                    SearchView(title: "Search All Highlights")
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    
                    SportSelectorView()
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                    
                    if viewModel.hasTodayHighlights {
                        HighlightSectionView(title: "Today", highlights: viewModel.todayHighlights)
                    }
                    
                    if viewModel.hasPastThreeDaysHighlights {
                        HighlightSectionView(title: "Past 3 Days", highlights: viewModel.pastThreeDaysHighlights)
                    }
                }
            }
        }
        .environmentObject(viewModel)
        .onAppear {
            if viewModel.hasNotFetchedYet {
                viewModel.loadHighlights()
            }
        }
    }
}

struct HighlightSectionView: View {
    let title: String
    let highlights: [Highlight]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            NavigationLink(destination: DetailedHighlightsView(title: title, highlights: highlights)) {
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
                HStack(spacing: 24) {
                    ForEach(highlights) { highlight in
                        HighlightTile(highlight: highlight, width: 241)
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
}
