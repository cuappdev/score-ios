//
//  PastGameTile.swift
//  score-ios
//
//  Created by Hsia Lu wu on 10/30/24.
//

import SwiftUI

struct PastGameTile: View {
    var game: Game
    
        
    var body: some View {
        let corScore = game.gameUpdates[game.gameUpdates.count-1].cornellScore
        let oppScore = game.gameUpdates[game.gameUpdates.count-1].opponentScore
        let corWon = corScore > oppScore
        let tie = corScore == oppScore
        
        HStack {
            // VStack of school names and logos and score
            ZStack {
                HStack {
                    Spacer() // Pushes the rectangle to the right side
                    Spacer()
                    Rectangle()
                        .frame(width: 2, height: 70) // Adjust the thickness of the right border here
                        .foregroundColor(Constants.Colors.gray_liner) // Color of the right border
                }
                
                VStack {
                    // Opponent score
                    HStack {
                        AsyncImage(url: URL(string: game.opponent.image)) { image in
                            image.image?.resizable()
                        }
                        .frame(width: 20, height: 20)

                        Text(game.opponent.name)
                            .font(Constants.Fonts.gameTitle)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        // Opponent Score with Arrow
                        if corWon {
                            Text(String(oppScore))
                                .foregroundStyle(Constants.Colors.gray_text)
                                .font(Constants.Fonts.medium18)
                        } else if !tie {
                            HStack {
                                Text(String(oppScore))
                                    .font(Constants.Fonts.semibold18)
                                Image("pastGame_arrow_back")
                                    .resizable()
                                    .frame(width: 11, height: 14)
                            }
                            .offset(x: 20)
                        } else {
                            Text(String(oppScore))
                                .font(Constants.Fonts.semibold18)
                        }
                        
                    }
                    
                    // Cornell Score
                    HStack {
                        Image("Cornell")
                            .resizable()
                            .frame(width: 20, height: 20)

                        Text("Cornell")
                            .font(Constants.Fonts.gameTitle)
                        
                        Spacer()
                        
                        // Cornell Score with Arrow
                        if corWon {
                            HStack {
                                Text(String(corScore))
                                    .font(Constants.Fonts.semibold18)
                                Image("pastGame_arrow_back")
                                    .resizable()
                                    .frame(width: 11, height: 14)
                            }
                            .offset(x: 20)
                        } else {
                            Text(String(corScore))
                                .foregroundStyle(Constants.Colors.gray_text)
                                .font(Constants.Fonts.medium18)
                        }
                    }
                }
                .padding(.leading, 16)
                .padding(.trailing, 24)
                .frame(maxWidth: .infinity)
            }
            
            // arrow
            
            
            // game info: sport, sex, time
            VStack {
                HStack(spacing: 8) {
                    // Sport icon
                    // TODO: frame 24*24
                    Image(game.sport.rawValue+"-g")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 19, height: 19)
                        .foregroundStyle(Constants.Colors.iconGray)
                    
                    // Sex icon
                    ZStack {
                        Circle()
                            .frame(width: 19, height: 19)
                            .foregroundStyle(.gray)
                        Image(game.sex.description)
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 19, height: 19)
                            .foregroundStyle(Constants.Colors.white)
                        // TODO: location icon ratio
                    }
                }
                .padding(.trailing, 20)
                .padding(.bottom, 22)
                
                HStack {
                    Text(Date.dateToString(date: game.date))
                        .font(Constants.Fonts.gameDate)
                        .foregroundStyle(Constants.Colors.gray_text)
                        .padding(.trailing, 20)
                }
            }
            .padding(.leading, 24)
        }
        .frame(width: 345, height: 96)
        .background(Constants.Colors.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Constants.Colors.gray_border, lineWidth: 1)
                .shadow(radius: 5)
        )
    }
}

#Preview {
    PastGameTile(game: Game.dummyData[7])
}
