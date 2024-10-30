//
//  FilterTile.swift
//  score-ios
//
//  Created by Daniel Chuang on 9/15/24.
//

import SwiftUI

struct FilterTile : View {
    
    var sport: Sport
    var selected: Bool
    
    var body : some View {
        let imageName: String = selected ? sport.rawValue+"-r": sport.rawValue+"-g"
        
        VStack(spacing: 6) {
            Image(imageName)
                .resizable()
                .renderingMode(.template)
                .frame(width: 32, height: 32)
                .foregroundStyle(selected ? Constants.Colors.selected : Constants.Colors.iconGray)
            Text(sport.description)
                .foregroundStyle(selected ? Constants.Colors.selected : Constants.Colors.iconGray)
                .font(Constants.Fonts.sportLabel)
        }
        .frame(minWidth: 56)
    }
}

#Preview () {
    FilterTile(sport: .Basketball, selected: true)
}
