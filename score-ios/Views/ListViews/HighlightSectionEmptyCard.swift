//
//  HighlightSectionEmptyCard.swift
//  score-ios
//

import SwiftUI

struct HighlightSectionEmptyCard: View {
    var body: some View {
        Text("Nothing to see here yet! Check back soon for new highlights.")
            .font(Constants.Fonts.Body.normal)
            .foregroundStyle(Constants.Colors.gray_text)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 28)
            .padding(.horizontal, 16)
            .background(Constants.Colors.white)
            .clipShape(.rect(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(Constants.Colors.gray_border, lineWidth: 1)
            }
    }
}

#Preview {
    HighlightSectionEmptyCard()
        .padding()
}
