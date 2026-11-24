//
//  HighlightSavedToast.swift
//  score-ios
//

import SwiftUI

struct HighlightSavedToast: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    let message: String
    var isError: Bool = false

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: isError ? "exclamationmark.triangle.fill" : "checkmark")
                .font(.system(size: 14, weight: .bold))
            Text(message)
                .font(Constants.Fonts.Body.medium)
                .lineLimit(2)
        }
        .foregroundStyle(Constants.Colors.white)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Constants.Colors.primary_red)
        .clipShape(.rect(cornerRadius: 12))
        .shadow(color: .black.opacity(0.12), radius: 8, y: 4)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isStaticText)
        .transition(reduceMotion ? .opacity : .move(edge: .bottom).combined(with: .opacity))
    }
}

#Preview {
    HighlightSavedToast(message: "Highlight saved! Manage in Profile.")
        .padding()
}
