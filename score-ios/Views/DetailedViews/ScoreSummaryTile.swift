//
//  ScoreSummaryTile.swift
//  score-ios
//
//  Created by Hsia Lu wu on 10/23/24.
//

import SwiftUI

struct ScoreSummaryTile: View {
    
    var winner: String
    var time: String
    var round: String
    var point: String
    var score: String
    
    var body: some View {
        HStack {
            // Team logo
            HStack {
                Image(winner)
                    .resizable()
                    .frame(width: 32, height: 32)
                HStack {
                    Text(time)
                        .font(Constants.Fonts.gameText)
                    Text(round)
                        .font(Constants.Fonts.gameText)
                }
                .padding(.leading, 12)
            }
            Spacer()
            
            HStack {
                Text(point)
                    .font(Constants.Fonts.buttonLabel)
                Text(score)
                    .font(Constants.Fonts.gameScore)
            }
        }
        .frame(height: 56)
        .padding(.horizontal, 24)
    }
}

#Preview {
    ScoreSummaryTile(winner: "Cornell", time: "6:21", round: "1st Quarter", point: "Field Goal", score: "10 - 7")
}
