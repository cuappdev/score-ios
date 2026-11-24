//
//  HighlightBookmarkChrome.swift
//  score-ios
//

import SwiftUI

struct HighlightBookmarkChrome: ViewModifier {
    @ObservedObject var viewModel: HighlightsViewModel
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                if let message = viewModel.toastMessage {
                    HighlightSavedToast(message: message, isError: viewModel.toastIsError)
                        .padding(.horizontal, 24)
                        .padding(.bottom, MainTab.scrollClearance)
                }
            }
            .animation(
                reduceMotion ? .easeInOut(duration: 0.15) : .spring(duration: 0.35),
                value: viewModel.toastMessage
            )
            .sheet(isPresented: $viewModel.showSignInToSave) {
                SignInToSaveSheet(
                    onDismiss: viewModel.dismissSignInToSave,
                    onAuthenticated: viewModel.handleSignInSuccess
                )
            }
    }
}

extension View {
    func highlightBookmarkChrome(viewModel: HighlightsViewModel = .shared) -> some View {
        modifier(HighlightBookmarkChrome(viewModel: viewModel))
    }
}
