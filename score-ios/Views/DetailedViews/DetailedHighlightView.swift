//
//  DetailedHighlightView.swift
//  score-ios
//
//  Created by Zain Bilal on 10/9/25.
//

import SwiftUI

struct DetailedHighlightsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: HighlightsViewModel
    
    var title: String
    var highlightScope: HighlightsScope
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 16, pinnedViews: [.sectionHeaders]) {
                
                // Custom header
                ZStack {
                    Text(title)
                        .font(Constants.Fonts.header)
                        .foregroundStyle(Constants.Colors.black)
                    
                    HStack {
                        Button(action: { dismiss() }) {
                            Image("arrow_back_ios")
                                .resizable()
                                .frame(width: 9.87, height: 18.57)
                        }
                        Spacer()
                    }
                }
                .padding(.top, 24)
                .padding(.horizontal, 24)
                
                Divider().background(.clear)
                
                Section(
                    header:
                        VStack(alignment: .leading, spacing: 0) {
                            SearchView(title: "Search \(title)", scope: highlightScope)
                                .padding(.horizontal, 24)
                                .padding(.top, 20)
                            
                            SportSelectorView()
                                .padding(.top, 20)
                        }
                        .padding(.bottom, 20)
                        .background(Color.white)
                    ,
                    content: {
                        VStack(alignment: .leading, spacing: 0) {
                            if(highlightsForScope.isEmpty) {
                                NoHighlightView()
                                    .frame(maxWidth: .infinity)
                                    .frame(minHeight: UIScreen.main.bounds.height - 350)
                                    // push view to the middle of the screen
                            }
                            else{
                                LazyVStack {
                                    ForEach(highlightsForScope, id: \.id) { highlight in
                                        HighlightTile(highlight: highlight, width: 360)
                                            .padding(.horizontal, 24)
                                            .padding(.top, 12)
                                    }
                                }
                            }
                        }
                    }
                )
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 200)
        }
        .environmentObject(viewModel)
        .onAppear {
            if viewModel.hasNotFetchedYet {
                viewModel.loadHighlights()
            }
            
            viewModel.clearSearch()
        }
        .onChange(of: viewModel.selectedSport) { _, _ in
            viewModel.filter()
        }
    }
    
    // MARK: - Helpers
    private var highlightsForScope: [Highlight] {
       switch highlightScope {
       case .today:
           return viewModel.detailedTodayHighlights
       case .pastThreeDays:
           return viewModel.detailedPastThreeDaysHighlights
       default:
           return viewModel.allHighlights
       }
   }
}

#Preview {
    DetailedHighlightsView(
        title: "Today",
        highlightScope: .pastThreeDays
    )
    .environmentObject(HighlightsViewModel.shared)
}
