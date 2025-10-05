//
//  CarouselView.swift
//  score-ios
//
//  Created by Hsi Lu wu on 2/24/25.
//

import SwiftUI

struct CarouselView<CardView: View, GameView: View>: View {
    @State private var selectedCardIndex: Int = 0
    var games: [Game]
    var title: String
    let cardView: (Game) -> CardView
    let gameView: (Game) -> GameView
    
    var body: some View {
            VStack (alignment: .center) {
                Text(title)
                    .font(Constants.Fonts.semibold24)
                    .foregroundStyle(Constants.Colors.black)
                    .frame(maxWidth: .infinity, alignment: .leading) // Align to the left
                    .padding(.top, 24)
                
                // Carousel
                TabView(selection: $selectedCardIndex) {
                    ForEach(games.indices, id: \.self) { index in
                        NavigationLink {
                            gameView(games[index])
                                .navigationBarBackButtonHidden()
                        } label: {
                            cardView(games[index])
                                .padding(.horizontal, 20)
                                .tag(index)
                        }
                    }
                }
                .frame(height: 220)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

                HStack(spacing: 32) {
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .fill(index == selectedCardIndex ? Constants.Colors.primary_red : Constants.Colors.unselected)
                            .frame(width: 10, height: 10)
                    }
                }
            }
   
            .padding(.bottom, 24)
    }

}
