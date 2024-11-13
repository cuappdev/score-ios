//
//  GameTile.swift
//  score-ios
//
//  Created by Daniel Chuang on 9/14/24.
//

import SwiftUI

// MARK: - Layout
private struct TileLayout {
    static let containerWidth: CGFloat = 345
    static let containerHeight: CGFloat = 96
    static let cornerRadius: CGFloat = 12
    static let borderWidth: CGFloat = 1
    static let shadowRadius: CGFloat = 5
    
    struct Padding {
        static let horizontal: CGFloat = 20
        static let iconSpacing: CGFloat = 8
        static let locationIconSpacing: CGFloat = 4
    }
    
    struct IconSize {
        static let sport: CGFloat = 24
        static let sex: CGFloat = 19
        static let location: CGSize = CGSize(width: 13.7, height: 20)
    }
}

private typealias TL = TileLayout

// MARK: - GameTile
struct GameTile: View {
    
    let game: Game
    
    private var isLiveNow: Bool {
        game.date == Date.currentDate
    }
    
    var body: some View {
        
        VStack {
            header
            footer
        }   .frame(width: TL.containerWidth, height: TL.containerHeight)
            .background(Constants.Colors.white)
            .clipShape(RoundedRectangle(cornerRadius: TL.cornerRadius))
            .background(
                RoundedRectangle(cornerRadius: TL.cornerRadius)
                    .stroke(Constants.Colors.gray_border, lineWidth: TL.borderWidth)
                    .shadow(radius: TL.shadowRadius)
            )

    }
}

private extension GameTile {
    private var header : some View {
        HStack {
            // Opponent Logo, Opponent Name
            HStack(spacing: TL.Padding.iconSpacing) {
                Image(game.opponent)

                Text(game.opponent)
                    .font(Constants.Fonts.gameTitle)
            }   .padding(.leading, TL.Padding.horizontal)
            
            Spacer()
        
            // Sport Icon, Sex Icon
            HStack(spacing: TL.Padding.iconSpacing) {
                // Sport icon
                Image(game.sport.rawValue+"-g")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: TL.IconSize.sport, height: TL.IconSize.sport)
                    .foregroundStyle(Constants.Colors.iconGray)
                
                // Sex icon
                ZStack {
                    Circle()
                        .frame(width: TL.IconSize.sex, height: TL.IconSize.sex)
                        .foregroundStyle(.gray)
                    Image(game.sex.description)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: TL.IconSize.sex, height: TL.IconSize.sex)
                        .foregroundStyle(Constants.Colors.white)
                }
            }
            .padding(.trailing, TL.Padding.horizontal)
        }
    }
    
    private var footer : some View {
        HStack {
            // Location Icon, City, State
            HStack (spacing: TL.Padding.locationIconSpacing) {
                Image(Constants.Icons.locationIcon)
                    .resizable()
                    .renderingMode(/*@START_MENU_TOKEN@*/.template/*@END_MENU_TOKEN@*/)
                    .frame(width: TL.IconSize.location.width, height: TL.IconSize.location.height)
                //TODO: ratio of location icon (actual dim: 10.83*15.83)
                    .foregroundStyle(Constants.Colors.iconGray)
                Text("\(game.city), \(game.state)")
                    .font(Constants.Fonts.gameText)
                    .foregroundStyle(Constants.Colors.gray_text)
            }   .padding(.leading, TL.Padding.horizontal)
            
            Spacer()
            
            // Date
            // TODO: Live Status / Date
            if (isLiveNow) {
                
            } else {
                HStack {
                    Text(Date.dateToString(date: game.date))
                        .font(Constants.Fonts.gameDate)
                        .foregroundStyle(Constants.Colors.gray_text)
                        .padding(.trailing, TL.Padding.horizontal)
                }
            }
        }
    }
}

// Preview
#Preview {
    GameTile(game: Game.dummyData[7])
}
