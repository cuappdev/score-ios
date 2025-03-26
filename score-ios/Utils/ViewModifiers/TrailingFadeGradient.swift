//
//  TrailingFadeGradient.swift
//  score-ios
//
//  Created by Jay Zheng on 3/20/25.
//

import SwiftUI

/// A view modifier that adds a trailing fade gradient to indicate scrollable content
struct TrailingFadeGradient: ViewModifier {
    var width: CGFloat
    var backgroundColor: Color
    
    init(width: CGFloat = 30, backgroundColor: Color = .white) {
        self.width = width
        self.backgroundColor = backgroundColor
    }
    
    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [.clear, backgroundColor]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: width)
                .allowsHitTesting(false),
                alignment: .trailing
            )
    }
}
// Add this as a view extension
extension View {
    /// Adds a trailing fade gradient to indicate scrollable content
    func withTrailingFadeGradient(width: CGFloat = 30, backgroundColor: Color = .white) -> some View {
        self.modifier(TrailingFadeGradient(width: width, backgroundColor: backgroundColor))
    }
}

