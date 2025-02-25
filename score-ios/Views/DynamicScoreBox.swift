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
    
    private var numberOfRounds: Int {
        switch game.sport {
        case .Baseball: return 9
        case .Basketball, .Soccer, .Volleyball: return 2
        case .IceHockey: return 3
        case .FieldHockey, .Football, .Lacrosse, .SprintFootball: return 4
        default: return 1
        }
    }
    
    private var cornellTotalScore: Int {
        if game.timeUpdates.count == numberOfRounds {
            return game.timeUpdates.reduce(0, { $0 + $1.cornellScore }) // sum up the score for each round
        } else if game.timeUpdates.count == numberOfRounds + 1 {
            // the last one is the sum
            return game.timeUpdates[game.timeUpdates.count-1].cornellScore
        } else if game.timeUpdates.count > numberOfRounds {
            var scores = game.timeUpdates[0..<numberOfRounds]
            return scores.reduce(0, { $0 + $1.cornellScore }) // sum up the score for each round
        }
        else {
            return -1
        }
    }
    
    private var opponentTotalScore: Int {
        if game.timeUpdates.count == numberOfRounds {
            return game.timeUpdates.reduce(0, { $0 + $1.opponentScore })
        } else if game.timeUpdates.count == numberOfRounds + 1 {
            // the last one is the sum
            return game.timeUpdates[game.timeUpdates.count-1].opponentScore
        } else if game.timeUpdates.count > numberOfRounds {
            var scores = game.timeUpdates[0..<numberOfRounds]
            return scores.reduce(0, { $0 + $1.opponentScore }) // sum up the score for each round
        } else {
            return -1
        }
    }
    
    var body: some View {
            let columnWidth = floor((345 - 100) / CGFloat(numberOfRounds))
            
            VStack {
                firstRow(columnWidth: columnWidth)
                secondRow(columnWidth: columnWidth)
                Rectangle() // Custom red divider
                    .fill(Constants.Colors.primary_red)
                    .frame(height: 0.8)
                thirdRow(columnWidth: columnWidth)
            }
            .frame(width: 345)
            .background(Constants.Colors.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Constants.Colors.primary_red, lineWidth: 1)
                    .shadow(radius: 5)
            )
     
    }
}


// MARK: Components
extension DynamicScoreBox {
    private func firstRow(columnWidth: CGFloat) -> some View {
        HStack(spacing: 0) {
            Text("")
                .font(Constants.Fonts.gameText)
                .frame(width: 60, alignment: .leading)
                
            
            ForEach(1...numberOfRounds, id: \..self) { round in
                Text("\(round)")
                    .frame(width: columnWidth)
            }
            .font(Constants.Fonts.gameText)
            
            Text("Total")
                .font(Constants.Fonts.gameText)
                .frame(width: 36)
                .padding(.trailing, 3)
                
        }
        .frame(width: 345, height: 40)
        .background(Constants.Colors.primary_red)
        .foregroundStyle(Constants.Colors.white)
    }
    
    private func secondRow(columnWidth: CGFloat) -> some View {
        HStack(spacing: 0) {
            Text("Cornell")
                .font(Constants.Fonts.gameText)
                .frame(width: 55, alignment: .leading)
                .padding(.leading, 5)
            
            ForEach(0..<numberOfRounds, id: \..self) { index in
                Text(game.timeUpdates.indices.contains(index) ? "\(game.timeUpdates[index].cornellScore)" : "-")
                    .frame(minWidth: columnWidth, maxWidth: columnWidth)
            }
            
            Text(cornellTotalScore != -1 ? "\(cornellTotalScore)" : "-")
                .frame(width: 36)
                .padding(.trailing, 3)
       
        }
        .frame(width: 345, height: 40)
        .foregroundStyle(.gray)
    }
    
    private func thirdRow(columnWidth: CGFloat) -> some View {
        HStack(spacing: 0) {
            Text(game.opponent.name)
                .lineLimit(1)
                .font(Constants.Fonts.gameText)
                .frame(width: 55, alignment: .leading)
                .padding(.leading, 5)
            
            ForEach(0..<numberOfRounds, id: \..self) { index in
                Text(game.timeUpdates.indices.contains(index) ? "\(game.timeUpdates[index].opponentScore)" : "-")
                    .frame(minWidth: columnWidth, maxWidth: columnWidth)
            }
            
            Text(opponentTotalScore != -1 ? "\(opponentTotalScore)" : "-")
                .frame(width: 36)
                .padding(.trailing, 3)
        }
        .frame(width: 345, height: 40)
        .foregroundStyle(.gray)
    }
}

let dummyGame: Game = Game(opponent:  Team(id: "673d2c20569abe4465e9f792", color: "blue", image: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/Cornell_University_seal.svg/1200px-Cornell_University_seal.svg.png", name: "Cornell"), city: "New York", state: "NY", date: Date.dateComponents(year: 2024, month: 5, day: 25, hour: 10, minute: 0), sport: .FieldHockey, address: "6 Fake St", sex: .Men, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: "05/19/2024", isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")])

#Preview {
    DynamicScoreBox(game: dummyGame)
}

// average column width of the middle columns
//    private var columnWidth: CGFloat {
//        let middleColumns = CGFloat(numberOfRounds)
//        return middleColumns > 0 ? (180 - 84) / middleColumns : 24
//    }
