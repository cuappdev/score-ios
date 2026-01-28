//
//  HighlightLoadinView.swift
//  score-ios
//
//  Created by Zain Bilal on 1/23/26.
//

import Foundation
import SwiftUI

// A full-page loading view that mimics the layout of the main game screens
struct HighlightLoadingView: View {

    private enum Layout {
        static let horizontalPadding: CGFloat = 24
        static let tileWidth: CGFloat = 241
        static let tileHeight: CGFloat = 192
        static let cornerRadius: CGFloat = 12
        static let sectionSpacing: CGFloat = 20
    }
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 4) {

                    titleSection
                    searchBar
                    sportSelector

                    highlightSection(title: "Today")
                    highlightSection(title: "Past 3 Days")
                }
                .shimmer()
            }
        }
    }
    
    // MARK: - Components

    private var titleSection: some View {
        HStack(spacing: 30) {
            Text("Loading Highlights...")
                .font(Constants.Fonts.semibold24)
                .foregroundStyle(Constants.Colors.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 24)
                .padding(.horizontal, 24)
            Spacer()
        }
    }

    private var searchBar: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(height: 44)
            .padding(.horizontal, 20)
            .padding(.top, 12)
    }

    private var sportSelector: some View {
        HStack{
            Spacer()
            
            HStack(spacing: 16) {
                ForEach(0..<5) { _ in
                    VStack(spacing: 9) {
                        Circle()
                            .frame(width: 40, height: 40)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .frame(width: 56, height: 17)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            
            Spacer()
        }
    }

    private func highlightSection(title:String) -> some View {
        
        return VStack(alignment: .leading, spacing: 0) {

            // Section header
            HStack {
                Text("Loading \(title)...")
                    .font(Constants.Fonts.subheader)
                    .foregroundStyle(Constants.Colors.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()

                RoundedRectangle(cornerRadius: 6)
                    .frame(width: 50, height: 14)
            }
            .padding(.top, Layout.sectionSpacing)
            .padding(.horizontal, Layout.horizontalPadding)

            // Horizontal tiles
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24) {
                    ForEach(0..<3) { _ in
                        RoundedRectangle(cornerRadius: Layout.cornerRadius)
                            .frame(
                                width: Layout.tileWidth,
                                height: Layout.tileHeight
                            )
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal, Layout.horizontalPadding)
            }
        }
    }
}

#Preview {
    HighlightLoadingView()
}
