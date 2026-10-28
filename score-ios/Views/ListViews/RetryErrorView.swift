//
//  RetryErrorView.swift
//  score-ios
//
//  Created by Zain Bilal on 9/27/26.
//

import SwiftUI

struct RetryErrorView: View {
    let title: String
    let retry: () async -> Void

    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()

                Image(systemName: "exclamationmark.bubble")
                    .resizable()
                    .frame(width: 64, height: 64)
                    .padding(.bottom, 16)

                Text(title)
                    .font(Constants.Fonts.Header.h2)
                    .padding(.bottom, 8)

                Text("Please try again later.")
                    .font(Constants.Fonts.Body.normal)

                Spacer()

                Button {
                    Task {
                        await retry()
                    }
                } label: {
                    HStack {
                        Image(systemName: "arrow.trianglehead.2.clockwise")
                        Text("Try again")
                            .font(Constants.Fonts.Body.medium)
                    }
                    .padding(.all, 10)
                }
                .background(Constants.Colors.crimson)
                .foregroundColor(Constants.Colors.white)
                .clipShape(Capsule())

                Spacer()
            }
        }
    }
}

struct GameErrorView: View {
    @ObservedObject var viewModel: GamesViewModel

    var body: some View {
        RetryErrorView(title: "Oops! Schedules failed to load.") {
            await viewModel.loadGames(forceNetwork: true)
        }
    }
}

struct HighlightErrorView: View {
    @EnvironmentObject var viewModel: HighlightsViewModel

    var body: some View {
        RetryErrorView(title: "Oops! Highlights failed to load.") {
            await viewModel.loadHighlights(forceNetwork: true)
        }
    }
}

#Preview {
    RetryErrorView(title: "Oops! Schedules failed to load.") {}
}
