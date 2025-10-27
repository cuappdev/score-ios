//
//  DetailedHighlightView.swift
//  score-ios
//
//  Created by Zain Bilal on 10/9/25.
//

import SwiftUI

struct DetailedHighlightsView: View {
    @Environment(\.dismiss) private var dismiss
    var title: String
    var highlights: [Highlight]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
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
                
                Divider()
                    .background(.clear)
                
                VStack(alignment: .leading, spacing: 0) {
                    SearchView(title: "Search \(title)")
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    
                    SportSelectorView()
                        .padding(.top, 20)
                    
                    VStack{
                        ForEach(highlights) { highlight in
                            HighlightTile(highlight: highlight, width:  360)
                                .padding(.horizontal, 24)
                                .padding(.top, 12)
                        }
                    }
                    .padding(.top, 20)
                }
                
               
            }
        }
        // hide default nav bar so only your custom one shows
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 200)
        }
    }
}

#Preview {
    DetailedHighlightsView(
        title: "Today",
        highlights: Highlight.dummyData
    )
    .environmentObject(HighlightsViewModel.shared)
}
