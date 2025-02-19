//
//  ScoreBox.swift
//  score-ios
//
//  Created by Hsia Lu wu on 2/14/25.
//
import Foundation
import SwiftUI
// baseball: 9
// basketball, soccer, volleyball: 2
// ice hockey: 3
// field hockey, football, lacrosse, sprint football: 4

// you can find the sport of this game in game.sport
// the box should have n+2 columns where n = the number of rounds in a game for this sport
// first column displays school names, last column displays total score, and the middle columns are the scores for each rounds
// the first column should have width 60, the last should have width 24, and the middle ones should have equal width
// game.timeUpdates is an array of timeUpdate, the score of ith round can be found in game.timeUpdates[i-1].cornellScore and game.timeUpdates[i-1].opponentScore
// if the the score hasn't been updated in timeUpdates yet, display '-' in the scorebox for that round
// total score should be the sum of the scores of all rounds after every round is finished (when timeUpdates has length n-1)

struct ScoreBox: View {
    var game: Game
    
    private var numberOfRounds: Int {
        switch game.sport {
        case .Baseball: return 9
        case .Basketball, .Soccer, .Volleyball: return 2
        case .IceHockey: return 3
        case .FieldHockey, .Football, .Lacrosse, .SprintFootball: return 4
        default: return 0
        }
    }
    
    private var cornellTotalScore: Int {
        if game.timeUpdates.count >= numberOfRounds {
            return game.timeUpdates.reduce(0, { $0 + $1.cornellScore }) // sum up the score for each round
        } else {
            return -1
        }
    }
    
    private var opponentTotalScore: Int {
        if game.timeUpdates.count >= numberOfRounds {
            return game.timeUpdates.reduce(0, { $0 + $1.opponentScore })
        } else {
            return -1
        }
    }
    
    // average column width of the middle columns
//    private var columnWidth: CGFloat {
//        let middleColumns = CGFloat(numberOfRounds)
//        return middleColumns > 0 ? (180 - 84) / middleColumns : 24
//    }
    
    var body: some View {
        GeometryReader { geometry in
            let availableWidth = geometry.size.width
            let columnWidth = max(24, (availableWidth - 96) / CGFloat(numberOfRounds))
            
            VStack {
                firstRow(columnWidth: columnWidth)
                secondRow(columnWidth: columnWidth)
                Rectangle() // Custom red divider
                    .fill(Constants.Colors.primary_red)
                    .frame(height: 0.8)
                thirdRow(columnWidth: columnWidth)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Constants.Colors.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Constants.Colors.primary_red, lineWidth: 1)
                    .shadow(radius: 5)
            )
        }
    }
}


// MARK: Components
extension ScoreBox {
    private func firstRow(columnWidth: CGFloat) -> some View {
        HStack {
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
                .frame(width: 24)
                .padding(.trailing, 3)
        }
        .frame(height: 40)
        .padding(.leading, 10)
        .background(Constants.Colors.primary_red)
        .foregroundStyle(Constants.Colors.white)
    }
    
    private func secondRow(columnWidth: CGFloat) -> some View {
        HStack {
            Text("Cornell")
                .font(Constants.Fonts.gameText)
                .frame(width: 60, alignment: .leading)
            
            ForEach(0..<numberOfRounds, id: \..self) { index in
                Text(game.timeUpdates.indices.contains(index) ? "\(game.timeUpdates[index].cornellScore)" : "-")
                    .frame(width: columnWidth)
            }
            
            Text(cornellTotalScore != -1 ? "\(cornellTotalScore)" : "-")
                .frame(width: 24)
        }
        .frame(height: 40)
        .padding(.leading, 10)
        .foregroundStyle(.gray)
    }
    
    private func thirdRow(columnWidth: CGFloat) -> some View {
        HStack {
            Text(game.opponent.name)
                .lineLimit(1)
                .font(Constants.Fonts.gameText)
                .frame(width: 60, alignment: .leading)
            
            ForEach(0..<numberOfRounds, id: \..self) { index in
                Text(game.timeUpdates.indices.contains(index) ? "\(game.timeUpdates[index].opponentScore)" : "-")
                    .frame(width: columnWidth)
            }
            
            Text(opponentTotalScore != -1 ? "\(opponentTotalScore)" : "-")
                .frame(width: 24)
        }
        .frame(height: 40)
        .padding(.leading, 10)
        .foregroundStyle(.gray)
    }
}

let dummyGame: Game = Game(opponent:  Team(id: "673d2c20569abe4465e9f792", color: "blue", image: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/Cornell_University_seal.svg/1200px-Cornell_University_seal.svg.png", name: "Cornell"), city: "New York", state: "NY", date: Date.dateComponents(year: 2024, month: 5, day: 25, hour: 10, minute: 0), sport: .Baseball, address: "6 Fake St", sex: .Men, timeUpdates: [TimeUpdate(timestamp: 1, isTotal: false, cornellScore: 13, opponentScore: 7)], gameUpdates: [GameUpdate(timestamp: 1, isTotal: false, cornellScore: 10, opponentScore: 7, time: "05/19/2024", isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD")])

#Preview {
    ScoreBox(game: dummyGame)
}
