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
    @State private var scrollPosition: String? = "top"
    @StateObject private var vm = GamesViewModel.shared
    @ObservedObject private var auth = AuthManager.shared
    @EnvironmentObject private var session: AppSession

    // Main view
    var body: some View {
        ZStack {
            NavigationStack {
                ScrollView(.vertical, showsIndicators: false) {
                    ZStack {
                        LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                            Color.clear
                                .frame(height: 0)
                                .id("top")

                            if session.showWelcome {
                                welcomeBanner
                                    .padding(.horizontal, paddingMain)
                                    .padding(.top, 30)
                            }
                            if !vm.topUpcomingGames.isEmpty {
                                CarouselView(games: vm.topUpcomingGames, title: "Upcoming",
                                             cardView: { game in
                                    UpcomingGameCard(game: game)
                                },
                                             gameView: { game in
                                    GameView(game: game, viewModel: PastGameViewModel(game: game))
                                })
                                .padding(.horizontal, paddingMain)
                            }

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
                        .scrollTargetLayout()
                        .safeAreaInset(edge: .bottom, content: {
                            Color.clear.frame(height: 20)
                        })
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .id(screenID)
                .scrollPosition(id: $scrollPosition, anchor: .top)
            }
            .task {
                guard vm.hasNotFetchedYet else { return }
                await vm.loadGames()
            }
            .refreshable {
                await vm.loadGames(forceNetwork: true)
            }
            .onChange(of: vm.selectedSport) {
                vm.filter()
            }
            .onChange(of: vm.selectedSex) {
                vm.filter()
            }
            .onDisappear {
                session.dismissWelcome()
            }

            if case .loading = vm.dataState {
                GameLoadingView(page: .upcoming, showsWelcome: session.showWelcome)
            }

            if case .error = vm.dataState {
                GameErrorView(viewModel: vm)
            }
        }
    }

    private var welcomeBanner: some View {
        HStack {
            Image("speaker")
                .resizable()
                .renderingMode(.template)
                .frame(width: 32, height: 32)
                .foregroundStyle(Constants.Colors.white)
            Text("Welcome to Score \(Text(auth.currentUser?.name ?? "User").font(Constants.Fonts.bodyBold))")
                .font(Constants.Fonts.medium14)
                .foregroundStyle(Constants.Colors.white)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(Constants.Colors.crimson)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.16), radius: 5, x: 0, y: 6)
    }

    // MARK: - Helpers

    private var isLoading: Bool {
        if case .loading = vm.dataState { return true }
        return false
    }

    /// Changes when loading finishes or the app is reopened, giving a fresh scroll view at the top.
    private var screenID: String {
        "\(session.openCount)-\(isLoading)"
    }
}

#Preview {
    UpcomingGamesView()
        .environmentObject(AppSession())
}
