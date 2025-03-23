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
        .background(Color.white)
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

#Preview {
    ScoringSummary(game: Game.dummyData[0])
}
