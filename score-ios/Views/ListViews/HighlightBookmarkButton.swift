//
//  HighlightBookmarkButton.swift
//  score-ios
//

import SwiftUI

struct HighlightBookmarkButton: View {
    let itemTitle: String
    let isBookmarked: Bool
    var isPending: Bool = false
    let action: () -> Void

    var body: some View {
        Button(isBookmarked ? "Remove bookmark for \(itemTitle)" : "Bookmark \(itemTitle)", systemImage: iconName, action: action)
            .labelStyle(.iconOnly)
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(Constants.Colors.primary_red)
            .frame(width: 32, height: 32)
            .background(Constants.Colors.white.opacity(0.92))
            .clipShape(.rect(cornerRadius: 8))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(Constants.Colors.primary_red.opacity(0.35), lineWidth: 1)
            }
            .frame(minWidth: 44, minHeight: 44)
            .contentShape(Rectangle())
            .opacity(isPending ? 0.45 : 1)
            .disabled(isPending)
            .sensoryFeedback(.selection, trigger: isBookmarked)
    }

    private var iconName: String {
        isBookmarked ? "bookmark.fill" : "bookmark"
    }
}

#Preview {
    HStack {
        HighlightBookmarkButton(itemTitle: "Cornell Hockey", isBookmarked: false, action: {})
        HighlightBookmarkButton(itemTitle: "Cornell Hockey", isBookmarked: true, action: {})
    }
    .padding()
    .background(Color.gray.opacity(0.3))
}
