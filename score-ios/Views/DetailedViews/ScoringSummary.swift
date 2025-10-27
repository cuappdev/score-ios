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
    var paddingMain: CGFloat = 20
    
    var body : some View {
        
//        Text("Scoring Summary")
//            .font(Constants.Fonts.semibold24)
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .padding(.horizontal, paddingMain)
////            .padding(.top, paddingMain)
//            .padding(.bottom, 1.5 * -paddingMain) // Negates carousel required title padding
        
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
                .font(.system(size: 24, weight: .bold))
                .padding(.vertical, paddingMain)
            }
            
            // Commented out to enable swipe navigation
//            ToolbarItem(placement: .navigationBarLeading) {
//                Button {
//                    presentationMode.wrappedValue.dismiss()
//                } label: {
//                    Image("arrow_back_ios")
//                        .resizable()
//                        .frame(width: 9.87, height: 18.57)
//                }
//            }
        }
//        .navigationBarBackButtonHidden()
        .toolbarBackground(Color.white, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

#Preview {
    ScoringSummary(game: Game.dummyData[0])
}
