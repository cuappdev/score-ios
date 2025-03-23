//
//  PastGameCard.swift
//  score-ios
//
//  Created by Hsia Lu wu on 11/6/24.
//

import SwiftUI

struct PastGameCard: View {
    var game: Game
    @ObservedObject var viewModel: PastGameViewModel
    
    var body: some View {
        VStack {
            banner

            Spacer()

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
    PastGameCard(game: Game.dummyData[7], viewModel: PastGameViewModel(game: Game.dummyData[7]))
}

// MARK: Components
extension PastGameCard {
    private var banner: some View {
        HStack {
            Spacer()
            
            Image("Cornell")
            .resizable()
            .frame(width: 64, height: 64)
            
            Spacer()
            
            HStack {
                Text(String(viewModel.cornellTotalScore))
                    .font(Constants.Fonts.title)
                    .italic()
                    .foregroundStyle(.white)
                
                Text(" - ")
                    .font(Constants.Fonts.title)
                    .italic()
                    .foregroundStyle(.white)
                
                // TODO: Change the blur
                Text(String(viewModel.opponentTotalScore))
                    .font(Constants.Fonts.title)
                    .blur(radius: 0.5)
                    .italic()
                    .foregroundStyle(.white)
            }
            
            Spacer()
            
            AsyncImage(url: URL(string: game.opponent.image)) {image in
                image.resizable()
            } placeholder: {
                Constants.Colors.gray_icons
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
                .frame(width: 25, height: 27)
                Text(game.opponent.name.removingUniversityPrefix())
                    .font(Constants.Fonts.gameTitle)
                    .foregroundStyle(Color.black)
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
        .padding(.horizontal, 20)
        .padding(.bottom, 13)
    }
}
