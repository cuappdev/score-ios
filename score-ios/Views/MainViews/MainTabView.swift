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
                } else if (selection == 1){
                    
                    HighlightsView()
                        .environmentObject(gamesViewModel)
                } else {
                    PastGamesView()
                        .environmentObject(gamesViewModel)
                }

                HStack {
                    ForEach(0..<2, id: \.self) {
                        index in
                        TabViewIcon(selectionIndex: $selection, itemIndex: index)
                            .frame(width: 67, height: 45)
                            .padding(.top, 10)
                        if index != 1 {
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal, 86)
                .padding(.bottom, 40)
                .frame(maxWidth: .infinity)
                .background(
                    Color.white
                        .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: -6)
                )

            }
            .ignoresSafeArea(edges: .bottom)
            .background(Color.white)
        }
    }
}

#Preview {
    MainTabView(selection: .constant(0))
}
