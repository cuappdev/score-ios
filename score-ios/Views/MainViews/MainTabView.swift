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
                        .toolbar(.hidden)
                        .navigationBarHidden(true)
                } else {
                    PastGamesView()
                        .environmentObject(gamesViewModel)
                        .toolbar(.hidden)
                        .navigationBarHidden(true)
                }

                HStack {
                    ForEach(0...2, id: \.self) {
                        index in
                        TabViewIcon(selectionIndex: $selection, itemIndex: index)
                            .frame(height: 45)
                            .padding(.top, 10)
                        if index != 2 {
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal, 48)
                .padding(.bottom, 40)
                .padding(.top, 8)
                .frame(maxWidth: .infinity)
                .background(
                    Color.white
                        .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: -6)
                )

            }
            .ignoresSafeArea(edges: .bottom)
            .background(Color.white)
            .toolbar(.hidden)
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    MainTabView(selection: .constant(0))
}
