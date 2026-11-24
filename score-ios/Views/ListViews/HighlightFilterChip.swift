//
//  HighlightFilterChip.swift
//  score-ios
//

import SwiftUI

struct HighlightFilterChip: View {
    let filter: HighlightsFilter
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: iconName)
                .font(.system(size: 11, weight: .regular))
            Text(filter.title)
                .font(Constants.Fonts.Label.normal)
        }
        .foregroundStyle(isSelected ? Constants.Colors.white : Constants.Colors.gray_text)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(isSelected ? Constants.Colors.primary_red : Constants.Colors.white)
        )
        .overlay {
            Capsule()
                .strokeBorder(
                    isSelected ? Constants.Colors.primary_red : Constants.Colors.gray_liner,
                    lineWidth: 1
                )
        }
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private var iconName: String {
        switch filter {
        case .all:
            return "square.grid.2x2"
        case .favorited:
            return "star"
        case .sport(let sport):
            switch sport {
            case .IceHockey, .FieldHockey:
                return "figure.hockey"
            case .Football:
                return "football"
            case .Basketball:
                return "basketball"
            case .Soccer:
                return "soccerball"
            case .Baseball:
                return "baseball"
            case .Lacrosse:
                return "sportscourt"
            case .All:
                return "square.grid.2x2"
            }
        }
    }
}

#Preview {
    HStack {
        HighlightFilterChip(filter: .all, isSelected: true)
        HighlightFilterChip(filter: .favorited, isSelected: false)
        HighlightFilterChip(filter: .sport(.IceHockey), isSelected: false)
    }
    .padding()
}
