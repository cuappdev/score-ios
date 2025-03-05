//
//  MainTabView.swift
//  score-ios
//
//  Created by Hsia Lu wu on 11/16/24.
//

import SwiftUI

struct MainTabView: View {
    // MARK: Properties
    @Binding var selection: Int
    @StateObject private var gamesViewModel = GamesViewModel.shared
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                if (selection == 0) {
                    UpcomingGamesView()
                        .environmentObject(gamesViewModel)
                } else {
                    PastGamesView()
                        .environmentObject(gamesViewModel)
                }
            }
            
            HStack {
                ForEach(0..<2, id: \.self) {
                    index in
                    TabViewIcon(selectionIndex: $selection, itemIndex: index)
                        .frame(width: 67, height: 45)
                    if index != 1 {
                        Spacer()
                    }
                }
            }
            .ignoresSafeArea(edges: .bottom)
            .padding(.leading, 86)
            .padding(.trailing, 86)
            .padding(.top, 10)
            .frame(maxWidth: .infinity)
            .background(Constants.Colors.white)
            .shadow(radius: 6)
            
        }
    }
}

#Preview {
    MainTabView(selection: .constant(0))
}
