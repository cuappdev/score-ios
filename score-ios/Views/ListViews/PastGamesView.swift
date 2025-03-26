//
//  PastGamesView.swift
//  score-ios
//
//  Created by Hsia Lu wu on 10/30/24.
//

import SwiftUI

struct PastGamesView: View {
    var paddingMain : CGFloat = 20

    // State variables
    @StateObject private var vm = GamesViewModel.shared
    @State private var showingFilterSheet = false

    var body: some View {
        ZStack {
            NavigationView {
                ScrollView(.vertical, showsIndicators: false) {
                    ZStack {
                        LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                            CarouselView(games: vm.topPastGames, title: "Latest",
                                         cardView: { game in
                                PastGameCard(game: game, viewModel: PastGameViewModel(game: game))
                            },
                                         gameView: { game in
                                GameView(game: game, viewModel: PastGameViewModel(game: game))
                            })
                            .padding(.horizontal, paddingMain)

                            Section(header: GameSectionHeaderView(showingFiltersheet: $showingFilterSheet, headerTitle: "All Scores")
                                .padding(.horizontal, paddingMain)) {

                                    // List of games
                                    GameListView(games: vm.selectedPastGames) { game in
                                        PastGameTile(game: game, viewModel: PastGameViewModel(game: game))
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
                .background(Color.white)
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
                GameLoadingView(page: .past)
            }

            if case .error = vm.dataState {
                GameErrorView(viewModel: vm)
            }
        }
    }
}

#Preview {
    PastGamesView()
}
