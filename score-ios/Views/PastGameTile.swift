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
        let liveNow: Bool = game.date == Date.currentDate
        
        VStack {
            // Opponent Logo, Opponent Name | Sport Icon, Sex Icon
            HStack(spacing: 8) {
                HStack(spacing: 8) {
                    Image(game.opponent.rawValue)

                    Text(game.opponent.rawValue)
                        .font(Constants.Fonts.gameTitle)
                }   .padding(.leading, 20)
                
                Spacer()
                
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
            }
            
            // Location Icon, City, State | Date
            HStack {
                HStack (spacing: 4) {
                    Image(Constants.Icons.locationIcon)
                        .resizable()
                        .renderingMode(/*@START_MENU_TOKEN@*/.template/*@END_MENU_TOKEN@*/)
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Constants.Colors.iconGray)
                    Text("\(game.city), \(game.state)")
                        .font(Constants.Fonts.gameText)
                        .foregroundStyle(Constants.Colors.gray_text)
                }   .padding(.leading, 20)
                
                Spacer()
                
                // TODO: Live Status / Date
                if (liveNow) {
                    
                } else {
                    HStack {
                        Text(Date.dateToString(date: game.date))
                            .font(Constants.Fonts.gameDate)
                            .foregroundStyle(Constants.Colors.gray_text)
                            .padding(.trailing, 20)
                    }
                }
            }
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
