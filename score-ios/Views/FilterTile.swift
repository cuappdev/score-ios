//
//  FilterTile.swift
//  score-ios
//
//  Created by Daniel Chuang on 9/15/24.
//

import SwiftUI

// MARK: - Layout
private struct TileLayout {
    static let iconSize: CGFloat = 32
    
    struct Padding {
        static let locationTextPadding: CGFloat = 6
    }
}

private typealias TL = TileLayout

// MARK: - FilterTile UI
struct FilterTile : View {
    
    var sport: Sport
    var selected: Bool
    
    var body : some View {
        let imageName: String = selected ? sport.rawValue+"-r": sport.rawValue+"-g"
        
        VStack(spacing: TL.Padding.locationTextPadding) {
            // Icon
            Image(imageName)
                .resizable()
                .renderingMode(.template)
                .frame(width: TL.iconSize, height: TL.iconSize)
                .foregroundStyle(selected ? Constants.Colors.selected : Constants.Colors.iconGray)
            
            // Text
            Text(sport.description)
                .foregroundStyle(selected ? Constants.Colors.selected : Constants.Colors.iconGray)
                .font(Constants.Fonts.sportLabel)
        }
    }
}

#Preview () {
    FilterTile(sport: .Basketball, selected: true)
}
