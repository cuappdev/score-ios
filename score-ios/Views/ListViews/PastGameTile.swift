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
        

        HStack {
            VStack(alignment: .leading, spacing: 16) {
                oppRow(oppWon: !(corWon || tie))

                corRow(corWon: corWon)
            }

            Spacer()

            winIndicator(corWon: corWon, oppWon: !(corWon || tie))

            gameInfo
        }
        .frame(height: 96)
        .padding(.horizontal, 16)
        .background(Constants.Colors.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Constants.Colors.gray_border, lineWidth: 1)
                .shadow(radius: 5)
        )
    }

    func oppRow(oppWon: Bool) -> some View {
        HStack {
            AsyncImage(url: URL(string: game.opponent.image)) { image in
                image.image?.resizable()
            }
            .frame(width: 20, height: 20)

            ScrollView(.horizontal, showsIndicators: false){
                Text(game.opponent.name.removingUniversityPrefix())
                    .font(Constants.Fonts.gameTitle)
                    .foregroundStyle(oppWon ? Constants.Colors.black : Constants.Colors.gray_text)
                    .lineLimit(1)
            }
            .withTrailingFadeGradient()

            Spacer()

            Text(viewModel.oppScore)
                .font(oppWon ? Constants.Fonts.semibold18 : Constants.Fonts.medium18)
                .foregroundStyle(Constants.Colors.gray_text)
        }
        .frame(maxWidth: .infinity)
    }

    func corRow(corWon: Bool) -> some View {
        HStack {
            Image("Cornell")
                .resizable()
                .frame(width: 20, height: 20)

            Text("Cornell")
                .font(Constants.Fonts.gameTitle)
                .foregroundStyle(corWon ? Constants.Colors.black: Constants.Colors.gray_text)

            Spacer()

            Text(viewModel.corScore)
                .font(corWon ? Constants.Fonts.semibold18 : Constants.Fonts.medium18)
                .foregroundStyle(Constants.Colors.gray_text)
        }
        .frame(maxWidth: .infinity)
    }

    func winIndicator(corWon: Bool, oppWon: Bool) -> some View {
        ZStack {
            Rectangle()
                .frame(width: 2, height: 72)
                .foregroundColor(Constants.Colors.gray_liner)

            VStack(spacing: 16) {
                ZStack {
                    // Invisible frame to maintain the 20x20 space
                    Rectangle()
                        .frame(width: 20, height: 20)
                        .opacity(0)

                    // Actual image at 11x14
                    Image("pastGame_arrow_back")
                        .resizable()
                        .frame(width: 11, height: 14)
                        .opacity(oppWon ? 1 : 0)
                        .offset(x: -6)
                }

                ZStack {
                    // Invisible frame to maintain the 20x20 space
                    Rectangle()
                        .frame(width: 20, height: 20)
                        .opacity(0)

                    // Actual image at 11x14
                    Image("pastGame_arrow_back")
                        .resizable()
                        .frame(width: 11, height: 14)
                        .opacity(corWon ? 1 : 0)
                        .offset(x: -6)
                }
            }
        }
    }

    var gameInfo: some View {
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

            Text(Date.dateToString(date: game.date))
                .font(Constants.Fonts.gameDate)
                .foregroundStyle(Constants.Colors.gray_text)
                .lineLimit(1)
        }
        .frame(width: 80)
    }

}

#Preview {
    PastGameTile(game: Game.dummyData[6], viewModel: PastGameViewModel(game: Game.dummyData[6]))
}
