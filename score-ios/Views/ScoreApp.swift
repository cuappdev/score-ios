//
//  ContentView.swift
//  score-ios
//
//  Created by Daniel Chuang on 9/4/24.
//

import SwiftUI

/// Main View of the app
struct ContentView: View {
    
    var body: some View {
        TabView {
            HomeView()
            .tabItem {
                VStack {
                    Image("schedule") // Replace with your custom image name
                        .renderingMode(.template)
                    Text("Schedule")
                }
            }
            
            // PastGameView as the secondary tab
            PastGameView()
                .tabItem {
                    VStack {
                        Image("scoreboard") // Replace with your custom image name
                            .renderingMode(.template)
                        Text("Scores")
                }
            }
        }
        .background(Color.white) 
        .accentColor(Constants.Colors.primary_red)
    }
}

#Preview {
    ContentView()
}
