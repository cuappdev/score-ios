//
//  ContentView.swift
//  score-ios
//
//  Created by Daniel Chuang on 9/4/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedSex : Sex = .Both
    @State private var selectedSport : Sport = .All
    
    var body: some View {
        NavigationView {
            VStack {
                // Sex selector
                PickerView(selectedSex: $selectedSex, selectedIndex: 0)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 12, trailing: 0))
                
                // Sport selector
                ScrollView (.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(Sport.allCases) { sport in
                            FilterTile(sport: sport, selected: sport == selectedSport)
                        }
                    }
                }   .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))
                
                // Seperator line
                Divider()
                
                // List of games
                ScrollView (.vertical, showsIndicators: false) {
                    LazyVStack() {
                        ForEach(
                            Game.dummyData.filter({selectedSex == .Both || $0.sex == selectedSex})
                        ) { game in
                            NavigationLink {
                                GameView(game: game)
                            } label : {
                                GameTile(game: game)
                            }   .buttonStyle(PlainButtonStyle())
                        }
                    }
                    
                }
            }   .padding()
                .edgesIgnoringSafeArea(.bottom)
        }
    }
}

#Preview {
    ContentView()
}
