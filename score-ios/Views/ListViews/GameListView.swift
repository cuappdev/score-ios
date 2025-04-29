//
//  GameListView.swift
//  score-ios
//
//  Created by Daniel Chuang on 2/24/25.
//

import SwiftUI

struct GameListView<TileView: View>: View {

    let games: [Game]
    let tileView: (Game) -> TileView

    @State private var displayedGamesCount = 10

    var body: some View {
        LazyVStack(spacing: 16) {
            if games.isEmpty {
                NoGameView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                // Calculate how many games to show (either displayedGamesCount or all games if less)
                let gamesToShow = min(displayedGamesCount, games.count)

                // Only display the subset of games
                ForEach(games.prefix(gamesToShow)) { game in
                    GeometryReader { cellGeometry in
                        let isCellCovered = cellGeometry.frame(in: .global).minY < 100
                        if !isCellCovered {
                            NavigationLink {
                                GameView(game: game, viewModel: PastGameViewModel(game: game))
                                    .navigationBarBackButtonHidden()
                            } label: {
                                tileView(game)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .frame(height: 96)
                }

                // Load More Button - only show if we haven't displayed all games yet
                if displayedGamesCount < games.count {
                    Button(action: {
                        // Increase the displayed games count by 10 more (or remaining count)
                        displayedGamesCount = min(displayedGamesCount + 10, games.count)
                    }) {
                        Text("Load More")
                            .font(Constants.Fonts.buttonLabel)
                            .foregroundStyle(Constants.Colors.white)
//                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Constants.Colors.primary_red)
                            .cornerRadius(8)
                    }
                    .clipShape(Capsule())
                    .padding(.top, 8)
                    .padding(.horizontal, 20)
                }

                // Temp Fix So the last cell is not covered by the tab bar
                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 100)
            }
        }
        .padding(.top, 16)
    }
}
