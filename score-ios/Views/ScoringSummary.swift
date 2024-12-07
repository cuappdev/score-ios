//
//  ScoringSummary.swift
//  score-ios
//
//  Created by Daniel Chuang on 12/4/24.
//

import SwiftUI

struct ScoringSummary : View {
    
    @Environment(\.presentationMode) var presentationMode
    var game: Game
    
    var body : some View {
        
        ScrollView (.vertical) {
            ForEach(game.gameUpdates.indices, id: \.self) { i in
                if game.gameUpdates[i].isCornell {
                    ScoringUpdateCell(update: game.gameUpdates[i], img: "Cornell")
                } else {
                    ScoringUpdateCell(update: game.gameUpdates[i], img: game.opponent.image)
                }
                
                if i < game.gameUpdates.count - 1 {
                    Divider()
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Scoring Summary")
                .font(.system(size: 27, weight: .regular))
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image("arrow_back_ios")
                        .resizable()
                        .frame(width: 9.87, height: 18.57)
                }
            }
        }
        .navigationBarBackButtonHidden()
        .toolbarBackground(Color.white, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

struct ScoringUpdateCell : View {
    var update: GameUpdate
    var img: String
    
    var body : some View {
        HStack {
            if update.isCornell {
                Image("Cornell")
                .resizable().frame(width: 32, height: 32)
            } else {
                AsyncImage(url: URL(string: img)) {image in
                    image.resizable().frame(width: 32, height: 32)
                } placeholder: {
                    Constants.Colors.gray_icons.frame(width: 32, height: 32)
                }
            }
            
            Spacer()
            
            VStack {
                Text("\("0:00") - \(ordinalNumberString(for: update.timestamp))")
                    .font(Constants.Fonts.regular14)
                
                if update.isCornell {
                    Text("**\(update.cornellScore)** - \(update.opponentScore)")
                        .font(Constants.Fonts.regular14)
                } else {
                    Text("\(update.cornellScore) - **\(update.opponentScore)**")
                        .font(Constants.Fonts.regular14)
                }
            }
            .frame(width:72)
            
            Spacer()
            
            Text(update.description)
                .font(Constants.Fonts.regular14)
                .frame(width: 217)
            
        }
        .padding(.leading, 24)
        .padding(.trailing, 24)
        .padding(.top, 12)
        .padding(.bottom, 12)
    }
}

#Preview {
    ScoringSummary(game: Game.dummyData[0])
}
