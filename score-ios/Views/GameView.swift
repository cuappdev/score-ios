//
//  GameView.swift
//  score-ios
//
//  Created by Mac User on 9/15/24.
//

import SwiftUI

struct GameView : View {
    var game : Game
    
    var body : some View {
        VStack {
            
            // Banner
            HStack {
                Spacer()
                Image("Cornell")
                    .resizable()
                    .frame(width: 72, height: 72)
                Spacer()
                Text("0 - 0")
                    .font(Constants.Fonts.title)
                    .foregroundColor(.gray)
                Spacer()
                
                // TODO: Fix dimension of logos
                Image("penn_logo")
                    .resizable()
                    .frame(width: 72, height: 72)
                Spacer()
            }
            .padding()
            .frame(height: 185)
            .background(LinearGradient(gradient: Gradient(colors: [
                Color(red: 179 / 255, green: 27 / 255, blue: 27 / 255, opacity: 0.4),
                Color(red: 1 / 255, green: 31 / 255, blue: 91 / 255, opacity: 0.4)
            ]), startPoint: .leading, endPoint: .trailing))
            
            // Game information
            VStack(alignment: .leading, spacing: 4) {
                Text("Men's Football")
                    .font(Constants.Fonts.subheader)
                Text("Cornell vs. " + game.opponent.rawValue)
                    .font(Constants.Fonts.header)
               
                HStack(spacing: 10) {
                    HStack {
                        Image("Alarm")
                        Text(Date.dateToString(date: game.date))
                    }
                    
                    // TODO: Fix location
                    HStack {
                        Image("Location-g")
                        Text("Ithaca (Schoellkopf)")
                    }
                }
                .font(Constants.Fonts.gameDate)
                .foregroundColor(.gray)
                .padding(.top, 10)
            }
            .padding()
            .padding(.trailing, 100)
            
            // Countdown
            VStack {
                Image("Hourglass")
                
                Text("Time Until Start")
                    .font(Constants.Fonts.bodyBold)
                
                HStack {
                    Text("2")
                        .font(Constants.Fonts.header)
                    
                    Text("days")
                        .font(Constants.Fonts.gameText)
                    Text("0")
                        .font(Constants.Fonts.header)
                    
                    Text("hours")
                        .font(Constants.Fonts.gameText)
                }
                .padding(.top, 5)
            }
            .padding(.top, 50)
            
        }
        .padding(.bottom, 180)
    }
}

#Preview {
    GameView(game: Game.dummyData[7])
}
