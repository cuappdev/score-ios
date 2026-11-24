//
//  LoginViewModel.swift
//  score-ios
//
//  Created by Duru Alaylı on 9/29/26.
//

import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import SwiftUI
import UIKit

@MainActor
final class LoginViewModel: ObservableObject {

    // MARK: - Properties

    @Published var didPresentError = false
    @Published var errorText = ""
    private let cornellDomain = "@cornell.edu"

    // MARK: - Sign In

    func signIn() async -> AuthManager.AuthResult? {
        guard let idToken = await signInWithGoogle() else { return nil }
        do {
            return try await AuthManager.shared.authenticate(idToken: idToken)
        } catch {
            showError("Couldn't sign in. Please try again.")
            return nil
        }
    }

    private func signInWithGoogle() async -> String? {
        guard let clientID = FirebaseApp.app()?.options.clientID,
              let presentingViewController = topViewController() else {
            showError("Sign in failed. Please try again.")
            return nil
        }
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
        do {
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController)
            guard let email = result.user.profile?.email, isValidEmail(email) else {
                GIDSignIn.sharedInstance.signOut()
                showError("Please sign in with your Cornell email")
                return nil
            }
            guard let googleIDToken = result.user.idToken?.tokenString else {
                showError("Sign in failed. Please try again.")
                return nil
            }
            let credential = GoogleAuthProvider.credential(
                withIDToken: googleIDToken,
                accessToken: result.user.accessToken.tokenString
            )
            let authResult = try await Auth.auth().signIn(with: credential)
            return try await authResult.user.getIDToken()
        } catch {
            if (error as? GIDSignInError)?.code == .canceled { return nil }
            showError("Sign in failed. Please try again.")
            return nil
        }
    }

    // MARK: - Helpers

    /// Prefer the top-most presented controller so Google Sign-In works from sheets.
    private func topViewController() -> UIViewController? {
        guard let root = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive })?
            .windows
            .first(where: \.isKeyWindow)?
            .rootViewController else {
            return nil
        }

        var top = root
        while let presented = top.presentedViewController, !presented.isBeingDismissed {
            if presented is UIAlertController { break }
            top = presented
        }
        return top
    }

    private func isValidEmail(_ email: String) -> Bool {
        email.hasSuffix(cornellDomain)
    }

    private func showError(_ message: String) {
        errorText = message
        didPresentError = true
    }
}
