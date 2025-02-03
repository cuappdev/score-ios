//
//  PastGameView.swift
//  score-ios
//
//  Created by Hsia Lu wu on 10/30/24.
//

import SwiftUI

struct PastGameView: View {
    // State variables
    @State private var selectedSex : Sex = .Both
    @State private var selectedSport : Sport = .All
    var paddingMain : CGFloat = 20
    @State private var selectedCardIndex: Int = 0
    @State private var games: [Game] = []
    @State private var allGames: [Game] = []
    @State private var errorMessage: String?
    @State private var pastGames: [Game] = []
    @EnvironmentObject var viewModel: GamesViewModel

    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                carousel
                
                VStack {
                    Text("All Scores")
                        .font(Constants.Fonts.semibold24)
                        .frame(maxWidth: .infinity, alignment: .leading) // Align to the left
                    
                    genderSelector
                        .frame(maxWidth: .infinity, alignment: .center)
                    sportSelector
                }
                .padding(.bottom, 16)
                
                // Seperator line
                Divider()
                    .background(.clear)
                
                gameList
                    .overlay {
                        if (games.isEmpty) {
                            NoGameView()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.leading, paddingMain)
            .padding(.trailing, paddingMain)
        }
        .onAppear {
            fetchPastGames()
        }
        .onChange(of: selectedSport) {
            filterPastGames()
        }
        .onChange(of: selectedSex) {
            filterPastGames()
        }
    }
}

#Preview {
    PastGameView()
}

// MARK: Functions
extension PastGameView {
    private func fetchPastGames() {
        NetworkManager.shared.fetchGames { fetchedGames, error in
            if let fetchedGames = fetchedGames {
                var updatedGames: [Game] = []
                let dispatchGroup = DispatchGroup()
                
                fetchedGames.indices.forEach { index in
                    let gameData = fetchedGames[index]
                    let game = Game(game: gameData)
//                    dispatchGroup.enter() // enter the dispatchGroup
                    
                    game.fetchAndUpdateOpponent(opponentId: gameData.opponentId) { updatedGame in
                        
                        // append the game only if it is upcoming/live
                        // TODO: How to determine whether it's live now
                        let now = Date()
                        let calendar = Calendar.current
                        let startOfToday = calendar.startOfDay(for: now)
                        
                        let isFinishedByToday = game.date < startOfToday
                        
                        if isFinishedByToday {
                            if (!updatedGame.gameUpdates.isEmpty) {
                                updatedGames.append(updatedGame)
                            }
                        }
                        
                        if index == fetchedGames.count - 1 {
                            self.games = updatedGames
                            self.allGames = updatedGames
                            self.pastGames = Array(allGames.prefix(3))
                            // Print updated game info to the console
//                            self.games.forEach { game in
//                                print("Game in \(game.city) on \(game.date), sport: \(game.sport), gender: \(game.sex), opponent: \(game.opponent.name)")
//                            }
                        }
                    }
                }
            }
            else if let error = error {
                self.errorMessage = error.localizedDescription
                print("Error in fetchGames: \(self.errorMessage ?? "Unknown error")")
            }
        }
    }
    
    private func filterPastGames() {
        let gender: String?
        let sport: String?
        if selectedSex == .Both {
            gender = nil
        } else {
            gender = selectedSex.filterDescription
        }
        if selectedSport == .All {
            sport = nil
        } else {
            sport = selectedSport.description
        }
        NetworkManager.shared.filterUpcomingGames(gender: gender, sport: sport) { filteredGames, error in
            if let filteredGames = filteredGames {
                var updatedGames: [Game] = []
                
                filteredGames.indices.forEach { index in
                    let gameData = filteredGames[index]
                    let game = Game(game: gameData)
//                    dispatchGroup.enter() // enter the dispatchGroup
                    
                    game.fetchAndUpdateOpponent(opponentId: gameData.opponentId) { updatedGame in
                        let now = Date()
                        let calendar = Calendar.current
                        let startOfToday = calendar.startOfDay(for: now)
                        
                        let isFinishedByToday = game.date < startOfToday
                        
                        if isFinishedByToday {
                            if(!updatedGame.gameUpdates.isEmpty) {
                                updatedGames.append(updatedGame)
                            }
                        }
                        
                        if (index == filteredGames.count - 1) {
                            self.games = updatedGames
                        }
//                        dispatchGroup.leave()
                    }
                }
                
//                dispatchGroup.notify(queue: .main) {
//                    self.games = updatedGames
//                }
            } else if let error = error {
                errorMessage = error.localizedDescription
                print("Error in filterPastGames: \(errorMessage ?? "Unknown error")")
            }
        }
    }
}

// MARK: Components
extension PastGameView {
    private var carousel: some View {
        VStack {
            Text("Latest")
                .font(Constants.Fonts.semibold24)
                .frame(maxWidth: .infinity, alignment: .leading) // Align to the left
                .padding(.top, 24)
            
            // Carousel
            TabView(selection: $selectedCardIndex) {
                ForEach(pastGames.indices, id: \.self) { index in
                    PastGameCard(game: pastGames[index])
                        .tag(index)
                }
            }
            .frame(height: 220)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            
            HStack(spacing: 32) {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(index == selectedCardIndex ? Constants.Colors.primary_red : Constants.Colors.unselected)
                        .frame(width: 10, height: 10)
                }
            }
        }
        .padding(.bottom, 24)
    }
    
    private var genderSelector: some View {
        PickerView(selectedSex: $selectedSex, selectedIndex: 0)
            .padding(.bottom, 12)
    }
    
    private var sportSelector: some View {
        ScrollView (.horizontal, showsIndicators: false) {
            HStack {
                ForEach(Sport.allCases) { sport in
                    Button {
                        selectedSport = sport
                    } label: {
                    FilterTile(sport: sport, selected: sport == selectedSport)
                    }
                }
            }
        }
    }
    
    private var filters: some View {
        // Sex selector
        // TODO: full-width to fit the screen
        VStack {
            PickerView(selectedSex: $selectedSex, selectedIndex: 0)
                .padding(.bottom, 12)
            
            // Sport selector
            ScrollView (.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(Sport.allCases) { sport in
                        Button {
                            selectedSport = sport
                        } label: {
                        FilterTile(sport: sport, selected: sport == selectedSport)
                        }
                    }
                }
            }
            .padding(.bottom, 16)
        }
    }
    
    private var gameList: some View {
        ScrollView (.vertical, showsIndicators: false) {
            LazyVStack(spacing: 16) {
                ForEach(
                    games
                ) { game in
                    NavigationLink {
                        GameView(game: game)
                            .navigationBarBackButtonHidden()
                    } label: {
                        PastGameTile(game: game)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }.padding(.top, paddingMain)
        }
    }
}
