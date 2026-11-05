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

@MainActor
final class LoginViewModel: ObservableObject {

    // MARK: - Properties

    @Published var didPresentError = false
    @Published var errorText = ""
    private let cornellDomain = "@cornell.edu"

    // MARK: - Sign in

    func signInWithGoogle() async -> String? {
        guard let clientID = FirebaseApp.app()?.options.clientID,
              let rootViewController = (UIApplication.shared.connectedScenes.first as?
                UIWindowScene)?.windows.first?.rootViewController else {
            showError("Sign in failed. Please try again.")
            return nil
        }
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
        do {
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
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

    private func isValidEmail(_ email: String) -> Bool {
        email.hasSuffix(cornellDomain)
    }

    func showError(_ message: String) {
        errorText = message
        didPresentError = true
    }
}
