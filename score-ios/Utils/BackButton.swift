//
//  BackButton.swift
//  score-ios
//
//  Created by Zain Bilal on 10/24/26.
//

import SwiftUI

struct BackButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image("arrow_back_ios")
                .frame(width: 44, height: 44)
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Back")
        .modifier(BackButtonCircle())
    }
}

extension ToolbarContent {
    @ToolbarContentBuilder
    func backButtonToolbarChrome() -> some ToolbarContent {
        if #available(iOS 26.0, *) {
            sharedBackgroundVisibility(.hidden)
        } else {
            self
        }
    }
}

private struct BackButtonCircle: ViewModifier {
    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content.glassEffect(.regular.interactive(), in: .circle)
        } else {
            content
        }
    }
}
