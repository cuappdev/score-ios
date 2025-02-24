//
//  PastGameView.swift
//  score-ios
//
//  Created by Hsia Lu wu on 10/30/24.
//

import SwiftUI

struct PastGameView: View {
    var paddingMain : CGFloat = 20
    
    // State variables
    @StateObject private var viewModel = GamesViewModel.shared

    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                ZStack {
                    LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                        carousel
                        
                        Section(header: gameSectionHeader
                            .padding(.leading, paddingMain)
                            .padding(.trailing, paddingMain)) {
                                
                            // List of games
                            gameList
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
            viewModel.fetchGames()
        }
        .onChange(of: viewModel.selectedSport) {
            viewModel.filter()
        }
        .onChange(of: viewModel.selectedSex) {
            viewModel.filter()
        }
    }
    
    private var gameSectionHeader: some View {
        VStack {
            VStack {
                Text("All Scores")
                    .font(Constants.Fonts.semibold24)
                    .frame(maxWidth: .infinity, alignment: .leading) // Align to the left
                
                genderSelector
                    .frame(maxWidth: .infinity, alignment: .center)
                sportSelector
            }
            .padding(.bottom, 16)
            
            Divider()
                .background(.clear)
        }
    }
}

#Preview {
    PastGameView()
}

//// MARK: Functions
//extension PastGameView {
//    private func fetchPastGames() {
//        NetworkManager.shared.fetchGames { fetchedGames, error in
//            if let fetchedGames = fetchedGames {
//                var updatedGames: [Game] = []
//                
//                fetchedGames.indices.forEach { index in
//                    let gameData = fetchedGames[index]
//                    let game = Game(game: gameData)
//                    
//                    let updatedGame = game
//                        
//                    // append the game only if it is upcoming/live
//                    // TODO: How to determine whether it's live now
//                    let now = Date()
//                    let calendar = Calendar.current
//                    let startOfToday = calendar.startOfDay(for: now)
//                    
//                    let isFinishedByToday = game.date < startOfToday
//                    
//                    if isFinishedByToday {
//                        if (!updatedGame.gameUpdates.isEmpty) {
//                            updatedGames.append(updatedGame)
//                        }
//                    }
//                    
//                    if index == fetchedGames.count - 1 {
//                        self.games = updatedGames
//                        self.allGames = updatedGames
//                        self.topPastGames = Array(allGames.prefix(3))
//                    }
//                }
//            }
//            else if let error = error {
//                self.errorMessage = error.localizedDescription
//                print("Error in fetchGames: \(self.errorMessage ?? "Unknown error")")
//            }
//        }
//    }
//    
//    private func filterPastGames() {
//        let gender: String?
//        let sport: String?
//        if selectedSex == .Both {
//            gender = nil
//        } else {
//            gender = selectedSex.filterDescription
//        }
//        if selectedSport == .All {
//            sport = nil
//        } else {
//            sport = selectedSport.description
//        }
//        NetworkManager.shared.filterUpcomingGames(gender: gender, sport: sport) { filteredGames, error in
//            if let filteredGames = filteredGames {
//                var updatedGames: [Game] = []
//                
//                filteredGames.indices.forEach { index in
//                    let gameData = filteredGames[index]
//                    let game = Game(game: gameData)
//                    
//                    let updatedGame = game
//                    let now = Date()
//                    let calendar = Calendar.current
//                    let startOfToday = calendar.startOfDay(for: now)
//                    
//                    let isFinishedByToday = game.date < startOfToday
//                    
//                    if isFinishedByToday {
//                        if(!updatedGame.gameUpdates.isEmpty) {
//                            updatedGames.append(updatedGame)
//                        }
//                    }
//                    
//                    if (index == filteredGames.count - 1) {
//                        self.games = updatedGames
//                    }
//                }
//            } else if let error = error {
//                errorMessage = error.localizedDescription
//                print("Error in filterPastGames: \(errorMessage ?? "Unknown error")")
//            }
//        }
//    }
//}

// MARK: Components
extension PastGameView {
    private var carousel: some View {
        VStack {
            Text("Latest")
                .font(Constants.Fonts.semibold24)
                .frame(maxWidth: .infinity, alignment: .leading) // Align to the left
                .padding(.top, 24)
                .padding(.leading, 24)
            
            // Carousel
            TabView(selection: $viewModel.selectedCardIndex) {
                ForEach($viewModel.topPastGames.indices, id: \.self) { index in
                    PastGameCard(game: viewModel.topPastGames[index])
                        .tag(index)
                }
            }
            .frame(height: 220)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            
            GeometryReader { geometry in
                if geometry.frame(in: .global).minY > 30 {
                    HStack(spacing: 32) {
                        ForEach(0..<3, id: \.self) { index in
                            Circle()
                                .fill(index == viewModel.selectedCardIndex ? Constants.Colors.primary_red : Constants.Colors.unselected)
                                .frame(width: 10, height: 10)
                        }
                    }
                    .position(x: geometry.frame(in: .local).midX)
                }
            }
            
        }
        .padding(.bottom, 24)
    }
    
    private var genderSelector: some View {
        PickerView(selectedSex: $viewModel.selectedSex, selectedIndex: viewModel.selectedSexIndex)
            .padding(.bottom, 12)
    }
    
    private var sportSelector: some View {
        ScrollView (.horizontal, showsIndicators: false) {
            HStack {
                ForEach(Sport.allCases) { sport in
                    Button {
                        viewModel.selectedSport = sport
                    } label: {
                        FilterTile(sport: sport, selected: sport == viewModel.selectedSport)
                    }
                }
            }
        }
    }
    
    private var gameList: some View {
        LazyVStack(spacing: 16) {
            if (viewModel.selectedPastGames.isEmpty) {
                NoGameView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ForEach(
                    viewModel.selectedPastGames
                ) { game in
                        GeometryReader { cellGeometry in
                            let isCellCovered = cellGeometry.frame(in: .global).minY < 100
                            if !isCellCovered {
                                NavigationLink {
                                    GameView(game: game)
                                        .navigationBarBackButtonHidden()
                                } label: {
                                    PastGameTile(game: game)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                }
                .frame(height: 96)
            }
        }
    }
}
