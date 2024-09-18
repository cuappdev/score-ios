//
//  GameTile.swift
//  score-ios
//
//  Created by Daniel Chuang on 9/14/24.
//

import SwiftUI

struct GameTile: View {
    
    var game: Game
    
    var body: some View {
        VStack {
            // Opponent Logo, Opponent Name | Sport Icon, Sex Icon
            HStack(spacing: 8) {
                HStack(spacing: 8) {
                    Image(game.opponent.rawValue)
                    Text(game.opponent.rawValue)
                        .font(Constants.Fonts.gameTitle)
                }   .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                
                Spacer()
                
                HStack(spacing: 8) {
                    Image(game.sport.rawValue)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 19, height: 19)
                        .foregroundColor(Constants.Colors.iconGrey)
                    ZStack {
                        Circle()
                            .frame(width: 19, height: 19)
                            .foregroundColor(.gray)
                        Image(game.sex.description)
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 19, height: 19)
                            .foregroundColor(Constants.Colors.white)
                    }
                }   .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
            }
            
            // Location Icon, City, State | Date
            HStack {
                HStack (spacing: 4) {
                    Image(Constants.Icons.locationIcon)
                        .resizable()
                        .renderingMode(/*@START_MENU_TOKEN@*/.template/*@END_MENU_TOKEN@*/)
                        .frame(width: 20, height: 20)
                        .foregroundColor(Constants.Colors.iconGrey)
                    Text("\(game.city), \(game.state)")
                        .font(Constants.Fonts.gameText)
                        .foregroundColor(Constants.Colors.grey_text)
                }   .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                
                Spacer()
                
                HStack {
                    Text(Date.dateToString(date: game.date))
                        .font(Constants.Fonts.gameDate)
                        .foregroundColor(Constants.Colors.grey_text)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
                }
            }
        }   .frame(width: 345, height: 96)
            .background(Constants.Colors.white)
//            .cornerRadius(12)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Constants.Colors.grey_border, lineWidth: 1)
                    .shadow(radius: 5)
            )

    }
}

// Preview
#Preview {
    GameTile(game: Game.dummyData[7])
}
