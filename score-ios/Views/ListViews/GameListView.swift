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
    
    var body: some View {
        LazyVStack(spacing: 16) {
            if games.isEmpty {
                NoGameView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ForEach(games) { game in
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
                }
                .frame(height: 96)

                // Temp Fix So the last cell is not covered by the tab bar
                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 100)
            }
        }
        .padding(.top, 16)
    }
}
