//
//  UpcomingGameCard.swift
//  score-ios
//
//  Created by Hsia Lu wu on 10/15/24.
//

import SwiftUI

struct UpcomingGameCard: View {
    
    var game: Game
    
    var body: some View {
        VStack {
            // banner
            banner
            
            Spacer()
            
            // information
            information
        }
        .frame(width: 345, height: 192)
        .background(Constants.Colors.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Constants.Colors.gray_border, lineWidth: 1)
                .shadow(radius: 5)
        )
        .padding(.vertical, 10)
    }
}

#Preview {
    UpcomingGameCard(game: Game.dummyData[7])
}

// MARK: Components
extension UpcomingGameCard {
    private var banner: some View {
        HStack {
            Spacer()
            Image("Cornell")
                .resizable()
                .frame(width: 64, height: 64)
            Spacer()
            Text("VS")
                .font(Constants.Fonts.title)
                .italic()
                .foregroundStyle(.white)
            Spacer()
            AsyncImage(url: URL(string: game.opponent.image)) {
                image in
                image.image?.resizable()
            }
            .frame(width: 64, height: 64)
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
                AsyncImage(url: URL(string: game.opponent.image)) {image in
                    image.resizable()
                } placeholder: {
                    Constants.Colors.gray_icons
                }
                .frame(width: 24, height: 24)
                
                Text(game.opponent.name)
                    .font(Constants.Fonts.gameTitle)
                    .foregroundStyle(Color.black)
                
                Spacer()
                
                Image(game.sport.rawValue + "-g")
                    .resizable()
                    .frame(width: 25, height: 25)
                
                Image(game.sex.description + "-g")
                    .resizable()
                    .frame(width: 25, height: 25)
            }
            
            HStack {
                Image("Location-g")
                    .resizable()
                    .frame(width: 13, height: 19)
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
