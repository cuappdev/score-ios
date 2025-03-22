//
//  DynamicScoreBox.swift
//  score-ios
//
//  Created by Hsia Lu wu on 2/24/25.
//
import Foundation
import SwiftUI

struct DynamicScoreBox: View {
    var game: Game
    @ObservedObject var viewModel: PastGameViewModel
    
    var body: some View {
        GeometryReader { geometry in
            let boxWidth = geometry.size.width
            let firstColWidth = boxWidth / 5
            let columnWidth = (boxWidth - firstColWidth) / CGFloat((viewModel.numberOfRounds + 1))

            VStack(spacing: 0) {
                firstRow(firstColWidth: firstColWidth, columnWidth: columnWidth)

                secondRow(firstColWidth: firstColWidth, columnWidth: columnWidth)

                Divider()
                    .background(Constants.Colors.primary_red)

                thirdRow(firstColWidth: firstColWidth, columnWidth: columnWidth)
            }
            .background(Constants.Colors.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Constants.Colors.primary_red, lineWidth: 1)
                    .shadow(radius: 5)
            )
        }
        .frame(height: 125)
    }
}


// MARK: Components
extension DynamicScoreBox {
    private func firstRow(firstColWidth: CGFloat, columnWidth: CGFloat) -> some View {
        HStack(spacing: 0) {
            Text("")
                .font(Constants.Fonts.gameText)
                .frame(width: firstColWidth, alignment: .leading)
            
            ForEach(1...viewModel.numberOfRounds, id: \..self) { round in
                Text("\(round)")
                    .frame(width: columnWidth)
            }
            .font(Constants.Fonts.gameText)
            
            Text("Total")
                .font(Constants.Fonts.gameText)
                .padding(.trailing, 3)
                .frame(width: columnWidth)
        }
        .padding(.vertical, 6)
        .background(Constants.Colors.primary_red)
        .foregroundStyle(Constants.Colors.white)
    }
    
    private func secondRow(firstColWidth: CGFloat, columnWidth: CGFloat) -> some View {
        HStack(spacing: 0) {
            Text("Cornell")
                .font(Constants.Fonts.gameText)
                .padding(.leading, 5)
                .frame(width: firstColWidth, alignment: .leading)
            
            ForEach(0..<viewModel.numberOfRounds, id: \..self) { index in
                Text(game.timeUpdates.indices.contains(index) ? "\(game.timeUpdates[index].cornellScore)" : "-")
                    .frame(minWidth: columnWidth, maxWidth: columnWidth)
            }
            
            Text(viewModel.cornellTotalScore != -1 ? "\(viewModel.cornellTotalScore)" : "-")
                .padding(.trailing, 3)
                .frame(width: columnWidth)
            
        }
        .foregroundStyle(.gray)
        .padding(.vertical, 12)
    }
    
    private func thirdRow(firstColWidth: CGFloat, columnWidth: CGFloat) -> some View {
        HStack(spacing: 0) {
            Text(game.opponent.name)
                .lineLimit(1)
                .font(Constants.Fonts.gameText)
                .padding(.leading, 5)
                .frame(width: firstColWidth, alignment: .leading)
            
            ForEach(0..<viewModel.numberOfRounds, id: \..self) { index in
                Text(game.timeUpdates.indices.contains(index) ? "\(game.timeUpdates[index].opponentScore)" : "-")
                    .frame(minWidth: columnWidth, maxWidth: columnWidth)
            }
            
            Text(viewModel.opponentTotalScore != -1 ? "\(viewModel.opponentTotalScore)" : "-")
                .padding(.trailing, 3)
                .frame(width: columnWidth)
        }
        .foregroundStyle(.gray)
        .padding(.vertical, 12)
    }
}

let dummyGame: Game = Game(opponent:  Team(id: "673d2c20569abe4465e9f792", color: "blue", image: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/Cornell_University_seal.svg/1200px-Cornell_University_seal.svg.png", name: "Cornell"), city: "New York", state: "NY", date: Date.dateComponents(year: 2024, month: 5, day: 25, hour: 10, minute: 0), sport: .FieldHockey, address: "6 Fake St", sex: .Men, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: "05/19/2024", isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")])

#Preview {
    DynamicScoreBox(game: dummyGame, viewModel: PastGameViewModel(game: dummyGame))
}

// average column width of the middle columns
//    private var columnWidth: CGFloat {
//        let middleColumns = CGFloat(numberOfRounds)
//        return middleColumns > 0 ? (180 - 84) / middleColumns : 24
//    }
