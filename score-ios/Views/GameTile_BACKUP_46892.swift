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
        let liveNow: Bool = game.date == Date.currentDate
        
        VStack {
            // Opponent Logo, Opponent Name | Sport Icon, Sex Icon
            HStack(spacing: 8) {
                HStack(spacing: 8) {
                    AsyncImage(url: URL(string: game.opponent.image)) {image in
                        image.resizable()
                    } placeholder: {
                        Constants.Colors.gray_icons
                    }
                    .frame(width: 20, height: 20)

                    Text(game.opponent.name)
                        .font(Constants.Fonts.gameTitle)
                        .lineLimit(1)
                }
                .padding(.leading, 20)
                
                Spacer()
                
                HStack(spacing: 8) {
<<<<<<< HEAD
//                    // Sport icon
//                    Image(game.sport.rawValue+"-g")
//                        .resizable()
//                        .renderingMode(.template)
//                        .scaledToFill()
//                        .frame(width: 19, height: 19)
//                        .foregroundStyle(Constants.Colors.iconGray)
                        
                    ZStack {
                        Circle()
                            .frame(width: 19, height: 19)
                            .foregroundStyle(.white)
                        Image(game.sport.rawValue+"-g")
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFill()
                            .frame(width: 19, height: 19)
                            .foregroundStyle(Constants.Colors.iconGray)
                    }
=======
                    // Sport icon
                    Image(game.sport.rawValue+"-g")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Constants.Colors.iconGray)
>>>>>>> main
                    
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
                        .frame(width: 13.7, height: 20)
<<<<<<< HEAD
=======
                    //TODO: ratio of location icon (actual dim: 10.83*15.83)
>>>>>>> main
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

// Preview
#Preview {
    GameTile(game: Game.dummyData[7])
}
