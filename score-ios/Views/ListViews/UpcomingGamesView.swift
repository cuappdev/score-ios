//
//  UpcomingGamesView.swift
//  score-ios
//
//  Created by Hsia Lu wu on 11/6/24.
//

import SwiftUI

struct UpcomingGamesView: View {

    // State variables
    var paddingMain: CGFloat = 20
    @State private var selectedCardIndex: Int = 0
    @StateObject private var vm = GamesViewModel.shared

    // Main view
    var body: some View {
        ZStack {
            NavigationView {
                ScrollView (.vertical, showsIndicators: false) {
                    ZStack {
                        LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                            CarouselView(games: vm.topUpcomingGames, title: "Upcoming",
                                         cardView: { game in
                                UpcomingGameCard(game: game)
                            },
                                         gameView: { game in
                                GameView(game: game, viewModel: PastGameViewModel(game: game))
                            })
                            .padding(.horizontal, paddingMain)
                            
                            
                            Section(header: GameSectionHeaderView(headerTitle: "Game Schedule")
                                .padding(.horizontal, paddingMain)) {
                                    
                                    // List of games
                                    GameListView(games: vm.selectedUpcomingGames) { game in
                                        UpcomingGameTile(game: game)
                                    }
                                    .padding(.horizontal, paddingMain)
                                }
                                .background(Color.white)
                                .edgesIgnoringSafeArea(.top)
                        }
                        .safeAreaInset(edge: .bottom, content: {
                            Color.clear.frame(height: 20)
                        })
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
            .onAppear {
                if vm.hasNotFetchedYet {
                    vm.fetchGames()
                }
            }
            .onChange(of: vm.selectedSport) {
                vm.filter()
            }
            .onChange(of: vm.selectedSex) {
                vm.filter()
            }

            if case .loading = vm.dataState {
                GameLoadingView(page: .upcoming)
            }

            if case .error = vm.dataState {
                GameErrorView(viewModel: vm)
            }
        }
    }
}

#Preview {
    UpcomingGamesView()
}
