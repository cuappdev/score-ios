//
//  PastGameTile.swift
//  score-ios
//
//  Created by Hsia Lu wu on 10/30/24.
//

import SwiftUI

struct PastGameTile: View {
    var game: Game
    @ObservedObject var viewModel: PastGameViewModel
        
    var body: some View {
        let corWon = viewModel.cornellTotalScore > viewModel.opponentTotalScore
        let tie = viewModel.cornellTotalScore == viewModel.opponentTotalScore
        let corScore = (viewModel.cornellTotalScore == -1) ? "-" : "\(viewModel.cornellTotalScore)"
        let oppScore = (viewModel.opponentTotalScore == -1) ? "-" : "\(viewModel.opponentTotalScore)"
        
        HStack {
            // VStack of school names and logos and score
            ZStack {
                HStack {
                    Spacer()
                    Rectangle()
                        .frame(width: 2, height: 70) // Adjust the thickness of the right border here
                        .foregroundColor(Constants.Colors.gray_liner) // Color of the right border
                }
                
                VStack(spacing: 16) {
                    // Opponent score
                    HStack {
                        AsyncImage(url: URL(string: game.opponent.image)) { image in
                            image.image?.resizable()
                        }
                        .frame(width: 20, height: 20)

                        if (corWon) {
                            ScrollView(.horizontal, showsIndicators: false){
                                Text(game.opponent.name.removingUniversityPrefix())
                                    .font(Constants.Fonts.gameTitle)
                                    .foregroundStyle(Constants.Colors.gray_text)
                                    .lineLimit(1)
                            }
                            .withTrailingFadeGradient()
                        } else {
                            ScrollView(.horizontal, showsIndicators: false){
                                Text(game.opponent.name.removingUniversityPrefix())
                                    .font(Constants.Fonts.gameTitle)
                                    .foregroundStyle(Constants.Colors.black)
                                    .lineLimit(1)
                            }
                            .withTrailingFadeGradient()
                        }
                        
                        
                        Spacer()
                        
                        // Opponent Score with Arrow
                        if corWon {
                            Text(oppScore)
                                .foregroundStyle(Constants.Colors.gray_text)
                                .font(Constants.Fonts.medium18)
                        } else if !tie {
                            // opponent won
                            HStack {
                                Text(oppScore)
                                    .font(Constants.Fonts.semibold18)
                                    .foregroundStyle(Constants.Colors.gray_text)
                                Image("pastGame_arrow_back")
                                    .resizable()
                                    .frame(width: 11, height: 14)
                            }
                            .offset(x: 20)
                        } else {
                            Text(oppScore)
                                .font(Constants.Fonts.medium18)
                                .foregroundStyle(Constants.Colors.gray_text)
                        }
                        
                    }
                    
                    // Cornell Score
                    HStack {
                        Image("Cornell")
                            .resizable()
                            .frame(width: 20, height: 20)

                        if (corWon) {
                            Text("Cornell")
                                .font(Constants.Fonts.gameTitle)
                                .foregroundStyle(Constants.Colors.black)
                        } else {
                            Text("Cornell")
                                .font(Constants.Fonts.gameTitle)
                                .foregroundStyle(Constants.Colors.gray_text)
                        }
                        
                        
                        Spacer()
                        
                        
                        // Cornell Score with Arrow
                        if corWon {
                            HStack {
                                Text(corScore)
                                    .foregroundStyle(Constants.Colors.gray_text)
                                    .font(Constants.Fonts.semibold18)
                                
                                Image("pastGame_arrow_back")
                                    .resizable()
                                    .frame(width: 11, height: 14)
                            }
                            .offset(x: 20)
                        } else if !tie {
                            // opponent won
                            Text(corScore)
                                .font(Constants.Fonts.medium18)
                                .foregroundStyle(Constants.Colors.gray_text)
                        } else {
                            Text(corScore)
                                .font(Constants.Fonts.medium18)
                                .foregroundStyle(Constants.Colors.gray_text)
                        }
                    }
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity)
            }
            
            // arrow
            
            
            // game info: sport, sex, time
            VStack(spacing: 16) {
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

                HStack {
                    Text(Date.dateToString(date: game.date))
                        .font(Constants.Fonts.gameDate)
                        .foregroundStyle(Constants.Colors.gray_text)
                        .padding(.trailing, 20)
                }
            }
            .padding(.leading, 24)
        }
        .frame(height: 96)
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
    PastGameTile(game: Game.dummyData[7], viewModel: PastGameViewModel(game: Game.dummyData[7]))
}
