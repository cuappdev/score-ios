//
//  SearchLoadingView.swift
//  score-ios
//
//  Created by Zain Bilal on 1/23/26.
//

import SwiftUI

struct HighlightSearchLoadingView: View {

    private enum Layout {
        static let horizontalPadding: CGFloat = 24
        static let tileHeight: CGFloat = 192
        static let tileCornerRadius: CGFloat = 12
        static let spacing: CGFloat = 24
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: Layout.spacing) {

                // Results count placeholder
                HStack {
                    RoundedRectangle(cornerRadius: 6)
                        .frame(width: 110, height: 20)
                        .padding(.horizontal, Layout.horizontalPadding)

                    Spacer()
                }

                // Search result tiles
                LazyVStack(alignment: .leading, spacing: Layout.spacing) {
                    ForEach(0..<5) { _ in
                        RoundedRectangle(cornerRadius: Layout.tileCornerRadius)
                            .frame(height: Layout.tileHeight)
                            .padding(.horizontal, Layout.horizontalPadding)
                    }
                }
            }
            .padding(.top, 12)
            .shimmer()
        }
    }
}

#Preview {
    HighlightSearchLoadingView()
}
