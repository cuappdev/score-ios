//
//  UpcomingGamesView.swift
//  score-ios
//
//  Created by Hsia Lu wu on 11/6/24.
//

import SwiftUI

struct UpcomingGamesView: View {
    // State variables
    var paddingMain : CGFloat = 20
    @State private var selectedCardIndex: Int = 0
    @StateObject private var vm = GamesViewModel.shared
    
    // Main view
    var body: some View {
        NavigationView {
            ScrollView (.vertical, showsIndicators: false) {
                ZStack {
                    LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                        CarouselView(games: vm.topUpcomingGames,
                                     cardView: { game in
                                         UpcomingGameCard(game: game)
                                     },
                                     gameView: { game in
                            GameView(game: game, viewModel: PastGameViewModel(game: game))
                                     })
                            .padding(.leading, paddingMain)
                            .padding(.trailing, paddingMain)
//                            .background(Color.white)
//                            .edgesIgnoringSafeArea(.top)

                        Section(header: GameSectionHeaderView(headerTitle: "Game Schedule")
                            .padding(.leading, paddingMain)
                            .padding(.trailing, paddingMain)) {
                                
                            // List of games
                            GameListView(games: vm.selectedUpcomingGames) { game in
                                UpcomingGameTile(game: game)
                                    }
                                .padding(.leading, paddingMain)
                                .padding(.trailing, paddingMain)
                        }
                        .background(Color.white)
                        .edgesIgnoringSafeArea(.top)
                    }
                    .safeAreaInset(edge: .bottom, content: {
                        Color.clear.frame(height: 20)
                    })
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .background(Color.white)
            }
            .background(Color.white)
        }
        .onAppear {
            vm.fetchGames()
        }
        .onChange(of: vm.selectedSport) {
            vm.filter()
        }
        .onChange(of: vm.selectedSex) {
            vm.filter()
        }
    }
}

#Preview {
    UpcomingGamesView()
}
