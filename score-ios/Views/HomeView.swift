//
//  HomeView.swift
//  score-ios
//
//  Created by Hsia Lu wu on 11/6/24.
//

import SwiftUI

struct HomeView: View {
    // State variables
    @State private var selectedSex : Sex = .Both
    @State private var selectedSport : Sport = .All
    var paddingMain : CGFloat = 20
    @State private var selectedCardIndex: Int = 0
    @State private var games: [Game] = []
    @State private var allGames: [Game] = []
    @State private var upcomingGames: [Game] = []
    @State private var errorMessage: String?
    
    // Main view
    var body: some View {
        NavigationView {
            ScrollView (.vertical, showsIndicators: false) {
                
                ZStack {
                    LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                        carousel
                            .padding(.leading, paddingMain)
                            .padding(.trailing, paddingMain)
                        
                        Section(header: gameSectionHeader
                            .padding(.leading, paddingMain)
                            .padding(.trailing, paddingMain)) {
                                
                            // List of games
                            gameList
                                .padding(.leading, paddingMain)
                                .padding(.trailing, paddingMain)
                        }.background(Color.white)
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
            fetchGames()
        }
        .onChange(of: selectedSport) {
            filterUpcomingGames()
        }
        .onChange(of: selectedSex) {
            filterUpcomingGames()
        }
    }
    
    private var gameSectionHeader: some View {
        VStack {
            VStack {
                Text("Game Schedule")
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
    HomeView()
}

// MARK: Functions
extension HomeView {
    private func fetchGames() {
        NetworkManager.shared.fetchGames { fetchedGames, error in
            if let fetchedGames = fetchedGames {
                var updatedGames: [Game] = []
                fetchedGames.indices.forEach { index in
                    let gameData = fetchedGames[index]
                    let game = Game(game: gameData)
                    
                    game.fetchAndUpdateOpponent(opponentId: gameData.opponentId) { updatedGame in
                        
                        // append the game only if it is upcoming/live
                        // TODO: How to determine whether it's live now
                        let now = Date()
                        let twoHours: TimeInterval = 2 * 60 * 60
                        let calendar = Calendar.current
                        let startOfToday = calendar.startOfDay(for: now)
                        
                        let isLive = game.date < now && now.timeIntervalSince(game.date) <= twoHours
                        let isUpcoming = game.date > now
                        let isFinishedToday = game.date < now && game.date >= startOfToday
                        
                        if isLive {
                            updatedGames.insert(updatedGame, at: 0)
                        } else if isUpcoming {
                            updatedGames.append(updatedGame)
                        } else if isFinishedToday {
                            updatedGames.append(updatedGame)
                        }
                        
                        if index == fetchedGames.count - 1 {
                            self.games = updatedGames
                            self.allGames = updatedGames
                            self.upcomingGames = Array(allGames.prefix(3))
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
    
    private func filterUpcomingGames() {
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
                    
                    game.fetchAndUpdateOpponent(opponentId: gameData.opponentId) { updatedGame in
                        let now = Date()
                        let twoHours: TimeInterval = 2 * 60 * 60
                        let calendar = Calendar.current
                        let startOfToday = calendar.startOfDay(for: now)
                        
                        let isLive = game.date < now && now.timeIntervalSince(game.date) <= twoHours
                        let isUpcoming = game.date > now
                        let isFinishedToday = game.date < now && game.date >= startOfToday
                        
                        if isLive {
                            updatedGames.insert(updatedGame, at: 0)
                        } else if isUpcoming {
                            updatedGames.append(updatedGame)
                        } else if isFinishedToday {
                            updatedGames.append(updatedGame)
                        }
                        
                        if index == filteredGames.count - 1 {
                            self.games = updatedGames
                        }
                    }
                }
            } else if let error = error {
                errorMessage = error.localizedDescription
                print("Error in filterUpcomingGames: \(errorMessage ?? "Unknown error")")
            }
        }
    }
}

// MARK: Components
extension HomeView {
    private var carousel: some View {
        VStack (alignment: .center) {
            Text("Upcoming")
                .font(Constants.Fonts.semibold24)
                .frame(maxWidth: .infinity, alignment: .leading) // Align to the left
                .padding(.top, 24)
            
            // Carousel
            TabView(selection: $selectedCardIndex) {
                ForEach(upcomingGames.indices, id: \.self) { index in
                    UpcomingCard(game: upcomingGames[index])
                        .tag(index)
                }
            }
            .frame(height: 220)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            
            // TODO: make this geometry reader only occur for iPhones with notches? Not sure, will need to check older phones
            GeometryReader { geometry in
                if geometry.frame(in: .global).minY > 30 {
                    HStack(spacing: 32) {
                        ForEach(0..<3, id: \.self) { index in
                            Circle()
                                .fill(index == selectedCardIndex ? Constants.Colors.primary_red : Constants.Colors.unselected)
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
        LazyVStack(spacing: 16) {
            if games.isEmpty {
                NoGameView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ForEach(
                    games
                ) { game in
                    GeometryReader { cellGeometry in
                        let isCellCovered = cellGeometry.frame(in: .global).minY < 100
                        if !isCellCovered {
                            NavigationLink {
                                GameView(game: game)
                                    .navigationBarBackButtonHidden()
                            } label: {
                                GameTile(game: game)
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
