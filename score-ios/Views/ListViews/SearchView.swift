//
//  SearchView.swift
//  score-ios
//
//  Created by Zain Bilal on 10/5/25.
//

import SwiftUI

struct SearchView: View {
    @State private var showSearch = false
    var highlights: [Highlight]
    let title: String

    var body: some View {
        Button(action: { showSearch = true }) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Constants.Colors.gray_text)
                
                Text("Search keywords")
                    .foregroundColor(Constants.Colors.gray_text)
                
                Spacer()
            }
            .padding(8)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Constants.Colors.gray_border, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .fullScreenCover(isPresented: $showSearch) {
            SearchViewFullScreen(title: title, allHighlights: highlights)
        }
    }
}


#Preview {
    SearchView(highlights: Highlight.dummyData, title: "Search All Highlights")
}
