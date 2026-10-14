//
//  SignInView.swift
//  score-ios
//
//  Created by Duru Alaylı on 9/29/26.
//

import SwiftUI

import SwiftUI

struct SignInView: View {

    // MARK: - Properties

    @State private var showIntro = !SignInView.hasShownIntro
    @State private var showButtons = SignInView.hasShownIntro
    static var hasShownIntro = false
    var onSignUp: (() -> Void)?
    var onLogIn: (() -> Void)?
    var onSignUpLater: (() -> Void)?

    // MARK: - Constants

    private let horizontalPadding: CGFloat = 24
    private let topPadding: CGFloat = 229
    private let bottomPadding: CGFloat = 64
    private let logoSize: CGFloat = 197
    private let buttonsSpacing: CGFloat = 24
    private let primaryButtonsSpacing: CGFloat = 16
    private let buttonPadding: CGFloat = 16

    // MARK: - UI

    var body: some View {
        ZStack {
            signInContent
            if showIntro {
                IntroAnimationView(onFinished: finishIntro)
            }
        }
    }

    // MARK: - Contents
    
    private var signInContent: some View {
        ZStack {
            Constants.Colors.crimson.ignoresSafeArea()
            VStack {
                logo
                Spacer()
                buttons
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.top, topPadding)
            .padding(.bottom, bottomPadding)
        }
    }

    private var logo: some View {
        Image("Logo")
            .resizable()
            .frame(width: logoSize, height: logoSize)
    }

    private var buttons: some View {
        VStack(spacing: buttonsSpacing) {
            VStack(spacing: primaryButtonsSpacing) {
                Button {
                    onSignUp?()
                } label: {
                    Text("Sign Up")
                        .font(Constants.Fonts.Header.h3)
                        .foregroundStyle(Constants.Colors.crimson)
                        .frame(maxWidth: .infinity)
                        .padding(buttonPadding)
                        .background(Constants.Colors.white)
                        .clipShape(Capsule())
                }
                .fadeIn(isVisible: showButtons, order: 0)
                Button {
                    onLogIn?()
                } label: {
                    Text("Log In")
                        .font(Constants.Fonts.Header.h3)
                        .foregroundStyle(Constants.Colors.white)
                        .frame(maxWidth: .infinity)
                        .padding(buttonPadding)
                        .background(Constants.Colors.crimson)
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(Constants.Colors.white, lineWidth: 1))
                }
                .fadeIn(isVisible: showButtons, order: 1)
            }
            Button {
                onSignUpLater?()
            } label: {
                Text("Sign Up Later")
                    .font(Constants.Fonts.sportLabel)
                    .foregroundStyle(Constants.Colors.white)
                    .frame(maxWidth: .infinity)
            }
            .fadeIn(isVisible: showButtons, order: 2)
        }
    }

    // MARK: - Helpers

    private func finishIntro() {
        SignInView.hasShownIntro = true
        showIntro = false
        showButtons = true
    }
}

// MARK: - Fade In

private extension View {
    func fadeIn(isVisible: Bool, order: Int) -> some View {
        self
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 12)
            .animation(
                .easeOut(duration: 0.3).delay(Double(order) * 0.12),
                value: isVisible
            )
            .disabled(!isVisible)
    }
}

#Preview {
    SignInView()
}
