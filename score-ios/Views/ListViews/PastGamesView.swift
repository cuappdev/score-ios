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
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                ZStack {
                    LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                        CarouselView(games: vm.topPastGames,
                                     cardView: { game in
                                         PastGameCard(game: game)
                                     },
                                     gameView: { game in
                                         GameView(game: game)
                                     })
                            .padding(.leading, paddingMain)
                            .padding(.trailing, paddingMain)
                        
                        Section(header: GameSectionHeaderView(headerTitle: "Past Scores")
                            .padding(.leading, paddingMain)
                            .padding(.trailing, paddingMain)) {
                                
                            // List of games
                            GameListView(games: vm.selectedPastGames) { game in
                                    PastGameTile(game: game)
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
            }
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
    PastGamesView()
}
