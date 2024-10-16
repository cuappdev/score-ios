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
    @State private var games: [Game] = []
    
    // Main view
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Sex selector
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
