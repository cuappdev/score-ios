//
//  GameLoadingView.swift
//  score-ios
//
//  Created by Jayson Hahn on 3/22/25.
//

import Foundation
import SwiftUI

/// The page types for loading states
enum LoadingPage: Equatable {
    case upcoming
    case past

    var title: String {
        switch self {
        case .upcoming: return "Upcoming"
        case .past: return "Latest"
        }
    }

    var subtitle: String {
        switch self {
        case .upcoming: return "Schedule"
        case .past: return "Scores"
        }
    }
}

/// A full-page loading view that mimics the layout of the main game screens
/// Used for both the upcoming games and past games tabs
struct GameLoadingView: View {

    let page: LoadingPage

    // Layout constants
    private enum Layout {
        static let horizontalPadding: CGFloat = 24
        static let verticalSpacing: CGFloat = 10
        static let cardCornerRadius: CGFloat = 10
        static let indicatorSize: CGFloat = 10
        static let scheduleCornerRadius: CGFloat = 25
        static let sportIconSize: CGFloat = 25
        static let gameCardCornerRadius: CGFloat = 12
        static let gameCardHeight: CGFloat = 100
    }

    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground)
                .edgesIgnoringSafeArea(.all)

            GeometryReader { geometry in
                VStack(alignment: .center, spacing: Layout.verticalSpacing) {
                    titleSection
                    carouselView
                    sexFilter
                    sportFilterSection

                    Divider()
                        .frame(minHeight: 1)
                        .background(Constants.Colors.gray_border)

                    gamesList

                    Spacer(minLength: 0)
                }
                .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
                .padding(.top, 50)
                .shimmer()
                .clipped()
            }
        }
    }

    // MARK: - Component Views

    private var titleSection: some View {
        HStack(spacing: 30) {
            Text("Loading \(page.title)...")
                .font(Constants.Fonts.Header.h1)
                .padding(.horizontal, Layout.horizontalPadding)
            Spacer()
        }
    }

    private var carouselView: some View {
        VStack {
            RoundedRectangle(cornerRadius: Layout.cardCornerRadius)
                .frame(width: 345, height: 192)
                .padding(.horizontal, Layout.horizontalPadding)
            HStack(spacing: 30) {
                Spacer()
                ForEach(0..<3) { _ in
                    Circle()
                        .frame(width: Layout.indicatorSize, height: Layout.indicatorSize)
                }
                Spacer()
            }
        }
        .padding(.vertical, 12)
    }

    private var sexFilter: some View {
        VStack(alignment: .leading, spacing: Layout.verticalSpacing) {
            Text("Loading \(page.subtitle)...")
                .font(Constants.Fonts.Header.h1)
                .padding(.vertical, 10)
                .padding(.horizontal, Layout.horizontalPadding)

            RoundedRectangle(cornerSize: CGSize(width: Layout.scheduleCornerRadius, height: Layout.scheduleCornerRadius))
                .frame(height: 50)
                .padding(.horizontal, Layout.horizontalPadding)
        }
    }

    private var sportFilterSection: some View {
        HStack(spacing: 15) {
            ForEach(0..<5) { _ in
                sportLoadingImage
            }
            Spacer()
        }
        .padding(.top, 20)
        .padding(.bottom, 10)
        .padding(.leading, Layout.horizontalPadding)
    }

    private var sportLoadingImage: some View {
        VStack(spacing: 10) {
            Circle()
                .frame(width: Layout.sportIconSize, height: Layout.sportIconSize)

            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                .frame(width: 60, height: 15)
        }
    }

    private var gamesList: some View {
        VStack(spacing: 15) {
            ForEach(0..<3) { _ in
                RoundedRectangle(cornerSize: CGSize(width: Layout.gameCardCornerRadius, height: Layout.gameCardCornerRadius))
                    .frame(height: Layout.gameCardHeight)
                    .padding(.horizontal, Layout.horizontalPadding)
            }
        }
        .padding(.top, 15)
    }

}

#Preview {
    VStack {
        GameLoadingView(page: .upcoming)
    }
}
