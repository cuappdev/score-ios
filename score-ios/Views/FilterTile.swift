//
//  FilterTile.swift
//  score-ios
//
//  Created by Daniel Chuang on 9/15/24.
//

import SwiftUI
import SwiftSVG

// MARK: - Layout
private struct TileLayout {
    static let iconSize: CGFloat = 32
    
    struct Padding {
        static let locationTextPadding: CGFloat = 6
    }
}

private typealias TL = TileLayout

// MARK: - SVG Render
struct SVGShape: Shape {
    let svg: SVG

    func path(in rect: CGRect) -> Path {
        let transformedPath = svg.path.cgPath(byTransforming: CGAffineTransform.identity.scaledBy(x: rect.width, y: rect.height).translatedBy(x: rect.minX, y: rect.minY))
        return Path(transformedPath)
    }
}

// MARK: - FilterTile UI
struct FilterTile : View {
    
    var sport: Sport
    var selected: Bool
    
    var body : some View {
//        let imageName: String = selected ? sport.rawValue+"-r": sport.rawValue+"-g"
        let imageName : String = sport.rawValue+"-g"
        let color: Color = selected ? Constants.Colors.primary_red : Constants.Colors.iconGray

        
        VStack(spacing: TL.Padding.locationTextPadding) {
            // Icon
            
            Image(imageName)
                .resizable()
                .renderingMode(.template)
                .frame(width: TL.iconSize, height: TL.iconSize)
                .blendMode(.destinationOut)
            
            ZStack {
                Image(imageName)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: TL.iconSize, height: TL.iconSize)
                    .foregroundStyle(color)

                if selected {
                    Rectangle()
                        .fill(.clear)
                        .frame(width: TL.iconSize, height: TL.iconSize)
                        .reverseMask{
                            Image(imageName)
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: TL.iconSize, height: TL.iconSize)
                                .foregroundStyle(color)
                        }
//                        .clipShape()
                }
            }.compositingGroup()
            

            
            // Text
            Text(sport.description)
                .foregroundStyle(selected ? Constants.Colors.selected : Constants.Colors.iconGray)
                .font(Constants.Fonts.sportLabel)
                .foregroundStyle(color)
        }
    }
}

#Preview () {
    FilterTile(sport: .Basketball, selected: true)
}

// https://stackoverflow.com/questions/73755862/swiftui-transparent-part-of-the-view-and-text
public extension View {
    @inlinable
    func reverseMask<Mask: View>(
        alignment: Alignment = .center,
        @ViewBuilder _ mask: () -> Mask
    ) -> some View {
        self.mask {
            Rectangle()
                .overlay(alignment: alignment) {
                    mask()
                        .blendMode(.destinationOut)
                }
        }
    }
}
