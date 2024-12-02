//
//  UpcomingCard.swift
//  score-ios
//
//  Created by Hsia Lu wu on 10/15/24.
//

import SwiftUI

struct UpcomingCard: View {
    
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
        .clipShape(RoundedRectangle(cornerRadius: 19))
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Constants.Colors.gray_border, lineWidth: 1)
                .shadow(radius: 5)
        )
        .padding(.vertical, 10)
    }
}

#Preview {
    UpcomingCard(game: Game.dummyData[7])
}

// MARK: Components
extension UpcomingCard {
    private var banner: some View {
        HStack {
            Spacer()
            Image("Cornell")
                .resizable()
                .frame(width: 50, height: 52)
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
            .frame(width: 50, height: 50)
//            Image("penn_logo")
//                .resizable()
//                .frame(width: 50, height: 58)
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
                Text(game.opponent.name)
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
