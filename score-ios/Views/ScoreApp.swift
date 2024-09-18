//
//  ContentView.swift
//  score-ios
//
//  Created by Daniel Chuang on 9/4/24.
//

import SwiftUI

// Main View of the app
struct ContentView: View {

    // State variables
    @State private var selectedSex : Sex = .Both
    @State private var selectedSport : Sport = .All
    var paddingMain : CGFloat = 20
    
    // Main view
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Sex selector
                PickerView(selectedSex: $selectedSex, selectedIndex: 0)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 12, trailing: 0))
                
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
                }   .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))
                
                // Seperator line
                Divider()
                    .background(.clear)
                
                // List of games
                ScrollView (.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 16) {
                        ForEach(
                            Game.dummyData.filter({(selectedSex == .Both || $0.sex == selectedSex) && (selectedSport == .All || $0.sport == selectedSport)})
                        ) { game in
                            NavigationLink {
                                GameView(game: game)
                            } label : {
                                GameTile(game: game)
                            }   .buttonStyle(PlainButtonStyle())
                        }
                    }.padding(EdgeInsets(top: paddingMain, leading: 0, bottom: 0, trailing: 0))
                    
                }
            }   .padding(EdgeInsets(top: 0, leading: paddingMain, bottom: 0, trailing: paddingMain))
                .edgesIgnoringSafeArea(.bottom)
        }
    }
}

#Preview {
    ContentView()
}
