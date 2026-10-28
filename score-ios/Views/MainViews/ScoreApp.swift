//
//  ContentView.swift
//  score-ios
//
//  Created by Daniel Chuang on 9/4/24.
//

import SwiftUI
import GameAPI

/// Main View of the app
struct ContentView: View {
    
    @State private var selectedTab: MainTab = .schedule  
    
    var body: some View {
        MainTabView(selectedTab: $selectedTab)
    }
}

#Preview {
    StateWrapper()
}

struct StateWrapper: View {
    @State private var selectedTab: MainTab = .schedule
    
    var body: some View {
        MainTabView(selectedTab: $selectedTab)
    }
}
