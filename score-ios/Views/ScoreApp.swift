//
//  ContentView.swift
//  score-ios
//
//  Created by Daniel Chuang on 9/4/24.
//

import SwiftUI

/// Main View of the app
struct ContentView: View {
    
    // State variables
    @State private var selectedSex : Sex = .Both
    @State private var selectedSport : Sport = .All
    var paddingMain : CGFloat = 20
    @State private var selectedCardIndex: Int = 0
    @State private var games: [Game] = []
    @State private var upcomingGames: [Game] = Array(Game.dummyData.prefix(3))
    
    // Main view
    var body: some View {
        NavigationView {
            
            VStack(spacing: 0) {
                
                VStack {
                    Text("Upcoming")
                        .font(Constants.Fonts.h1) 
                        .frame(maxWidth: .infinity, alignment: .leading) // Align to the left
                        .padding(.leading, 20)
                        .padding(.top, 24)
                    
                    VStack {
                    }
                    
                    // Carousel
                    TabView(selection: $selectedCardIndex) {
                        ForEach(upcomingGames.indices, id: \.self) { index in
                            UpcomingCard(game: upcomingGames[index])
                                .tag(index)
                        }
                    }
                    .frame(height: 220)
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                    
                    HStack(spacing: 32) {
                        ForEach(0..<3, id: \.self) { index in
                            Circle()
                                .fill(index == selectedCardIndex ? Constants.Colors.primary_red : Color(red: 194 / 255, green: 194 / 255, blue: 194 / 255, opacity: 1))
                                .frame(width: 10, height: 10)
                        }
                    }
                    
                }
                .padding(.bottom, 24)
                
                Text("Game Schedule")
                    .font(Constants.Fonts.h1)
                    .frame(maxWidth: .infinity, alignment: .leading) // Align to the left
                    .padding(.leading, 20)
                    .padding(.bottom, 16)
                
                // Sex selector
                PickerView(selectedSex: $selectedSex, selectedIndex: 0)
                    .padding(.bottom, 12)
                // TODO: full-width to fit the screen
                
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
                }   .padding(.bottom, 16)
                
                // Seperator line
                Divider()
                    .background(.clear)
                
                
                // List of games
                if (games.isEmpty) {
                    // make this a separate view
                    NoGameView()
                } else {
                    ScrollView (.vertical, showsIndicators: false) {
                        LazyVStack(spacing: 16) {
                            ForEach(
                                games
                            ) { game in
                                NavigationLink {
                                    GameView(game: game)
                                } label : {
                                    GameTile(game: game)
                                }   .buttonStyle(PlainButtonStyle())
                            }
                        }.padding(.top, paddingMain)
                        
                    }
                }
            }   .padding(.leading, paddingMain)
                .padding(.trailing, paddingMain)
                .edgesIgnoringSafeArea(.bottom)
        }.onAppear {
//            filterGames()
        }
        .onChange(of: selectedSport) {
            filterGames()
        }
        .onChange(of: selectedSex) {
            filterGames()
        }
    }
    
    func filterGames() {
        games = Game.dummyData.filter({(selectedSex == .Both || $0.sex == selectedSex) && (selectedSport == .All || $0.sport == selectedSport)})
    }
}



#Preview {
    ContentView()
}
