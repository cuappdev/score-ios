//
//  GameCard.swift
//  score-ios
//
//  Created by Mac User on 11/14/24.
//

import SwiftUI

struct GameCard: View {
    var game: Game
    var body: some View {
        VStack {
            banner
            Spacer()
            information
        }.frame(width: 345, height: 192)
            .background(Constants.Colors.white)
            .clipShape(RoundedRectangle(cornerRadius: 19))
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Constants.Colors.gray_border, lineWidth: 1)
                    .shadow(radius: 5)
            )
            .padding(.vertical, 10)
    }
}

// MARK: Components
extension GameCard {
    private var banner: some View {
        HStack {
            Spacer()
            Image("Cornell")
                .resizable()
                .frame(width: 50, height: 52)
            Spacer()
            
            HStack {
                Text("47")
                    .font(Constants.Fonts.title)
                    .italic()
                    .foregroundStyle(.white)
                
                Text(" - ")
                    .font(Constants.Fonts.title)
                    .italic()
                    .foregroundStyle(.white)
                
                // TODO: Change the blur
                Text("23")
                    .font(Constants.Fonts.title)
                    .blur(radius: 0.5)
                    .italic()
                    .foregroundStyle(.white)
            }
            
            Spacer()
            Image("penn_logo")
                .resizable()
                .frame(width: 50, height: 58)
            Spacer()
        }
        .padding()
        .frame(height: 100)
        .background(LinearGradient(gradient: Gradient(colors: [
            Constants.Colors.gradient_red,
            Constants.Colors.gradient_blue
        ]), startPoint: .leading, endPoint: .trailing))
    }
    
    private var information: some View {
        VStack {
            HStack {
                Image("penn_logo")
                    .resizable()
                    .frame(width: 24, height: 30)
                Text(game.opponent)
                    .font(Constants.Fonts.gameTitle)
                Spacer()
                Image(game.sport.rawValue + "-g")
                    .resizable()
                    .frame(width: 30, height: 30)
                Image(game.sex.description + "-g")
                    .resizable()
                    .frame(width: 25, height: 25)
            }
            
            HStack {
                Image("Location-g")
                    .resizable()
                    .frame(width: 10, height: 15)
                Text("\(game.city), \(game.state)")
                    .font(Constants.Fonts.gameText)
                    .foregroundStyle(.gray)
                Spacer()
                Text(Date.dateToString(date: game.date))
                    .font(Constants.Fonts.gameDate)
                    .foregroundStyle(.gray)
            }
        }
        .padding(.leading, 20)
        .padding(.trailing, 20)
        .padding(.bottom, 13)
    }
}

#Preview {
    GameCard(game: Game.dummyData[7])
}
