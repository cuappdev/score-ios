//
//  HighlightView.swift
//  score-ios
//
//  Created by Zain Bilal on 10/4/25.
//

import SwiftUI

struct HighlightView: View {
    @State var highlights: [Highlight]
    
    var body: some View {
        // Filter highlights
        let todayHighlights = highlights.filter {
            if let date = Date.fullDateFormatter.date(from: $0.publishedAt) {
                return Date.isWithinPastDays(date, days: 1)
            }
            return false
        }

        let pastThreeDaysHighlights = highlights.filter {
            guard let date = Date.fullDateFormatter.date(from: $0.publishedAt) else { return false }
            return !Date.isWithinPastDays(date, days: 1) && Date.isWithinPastDays(date, days: 3)
        }

        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Highlights")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                    
                        
                    SearchView(highlights: highlights, title: "Search All Highlights")
                    .padding(.horizontal, 24)
                    .padding(.bottom, 12)
                    
                    SportSelectorView()
                        .padding(.bottom, 12)
                    
                    
                    if !todayHighlights.isEmpty {
                        HighlightSectionView(title: "Today", highlights: todayHighlights)
                    }
                    
                    if !pastThreeDaysHighlights.isEmpty {
                        HighlightSectionView(title: "Past 3 Days", highlights: pastThreeDaysHighlights)
                    }
                }
            }
        }
    }
}

struct HighlightSectionView: View {
    let title: String
    let highlights: [Highlight]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            NavigationLink(destination: DetailedHighlightsView(title: title, highlights: highlights)) {
                HStack {
                    Text(title)
                        .font(Constants.Fonts.subheader)
                        .foregroundStyle(Constants.Colors.black)
                    
                    Spacer()
                    
                    Text("\(highlights.count) results")
                        .font(Constants.Fonts.body)
                        .foregroundStyle(Constants.Colors.gray_text)
                    
                    Image(systemName: "chevron.right")
                        .font(Constants.Fonts.body)
                        .foregroundStyle(Constants.Colors.gray_text)
                }
                .padding(.horizontal, 24)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24) {
                    ForEach(highlights) { highlight in
                        HighlightTile(highlight: highlight, width: 241)
                    }
                }
                .padding(.horizontal, 24)
            }
        }
    }
}


// MARK: - Preview

#Preview {
    HighlightView(highlights: Highlight.dummyData)
}
