//
//  Created by Daniel Chuang on 9/15/24.
//

import SwiftUI

struct FilterTile : View {
    
    var sport: Sport
    var selected: Bool
    
    var body : some View {
        VStack(spacing: 6) {
            
            if (selected) {
                Image(sport.rawValue+"-r")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 32, height: 32)
                    .foregroundStyle(Constants.Colors.selected)
            } else {
                Image(sport.rawValue+"-g")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 32, height: 32)
                    .foregroundStyle(Constants.Colors.iconGray)
            }
            
            Text(sport.description)
                .foregroundStyle(selected ? Constants.Colors.selected : Constants.Colors.iconGray)
                .font(Constants.Fonts.sportLabel)
        }
        .frame(minWidth: 56)
    }
}

#Preview () {
    FilterTile(sport: .Soccer, selected: false)
}
