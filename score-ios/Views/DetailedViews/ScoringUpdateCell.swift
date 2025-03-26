//
//  ScoringUpdateCell.swift
//  score-ios
//
//  Created by Daniel Chuang on 2/12/25.
//

import SwiftUI

struct ScoringUpdateCell : View {
    var update: GameUpdate
    var img: String
    
    var body : some View {
        HStack {
            if update.isCornell {
                Image("Cornell")
                    .resizable()
                    .frame(width: 32, height: 32)
            } else {
                AsyncImage(url: URL(string: img)) { image in
                    image
                        .resizable()
                        .frame(width: 32, height: 32)
                } placeholder: {
                    Constants.Colors.gray_icons
                        .frame(width: 32, height: 32)
                }
            }
            
            Spacer()
            
            VStack {
                Text("\(update.time) - \(ordinalNumberString(for: update.timestamp))")
                    .font(Constants.Fonts.regular14)
                    .foregroundStyle(Constants.Colors.black)
                
                if update.isCornell {
                    Text("**\(update.cornellScore)** - \(update.opponentScore)")
                        .font(Constants.Fonts.regular14)
                        .foregroundStyle(Constants.Colors.black)

                } else {
                    Text("\(update.cornellScore) - **\(update.opponentScore)**")
                        .font(Constants.Fonts.regular14)
                        .foregroundStyle(Constants.Colors.black)

                }
            }
            .frame(width:72)
            
            Spacer()
            
            Text(update.description)
                .font(Constants.Fonts.regular14)
                .foregroundStyle(Constants.Colors.black)
                .frame(width: 217)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
    }
}

#Preview {
    ScoringUpdateCell(update: GameUpdate(timestamp: 2, isTotal: false, cornellScore: 10, opponentScore: 7, time: "2:12", isCornell: true, eventParty: EventParty.Cornell, description: "Zhao, Alan field goal attempt from 24 GOOD"), img: "Cornell")
}
