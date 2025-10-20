//
//  AuthClient.swift
//  Center
//
//  Created by Jidong Zheng on 10/19/25.
//

import ComposableArchitecture
import FirebaseAuth
import GoogleSignIn

enum GoogleAuthError: Error, LocalizedError {
    case noUserSignedIn
    case noPresentingViewController
    case noIDToken
    
    var errorDescription: String? {
        switch self {
        case .noUserSignedIn:
            return "No user is currently signed in"
        case .noPresentingViewController:
            return "Unable to present sign-in interface"
        case .noIDToken:
            return "Google ID token not available"
        }
    }
}

@DependencyClient
struct AuthClient{
    var authStatePublisher: @Sendable () -> AsyncStream<FirebaseAuth.User?> = { .never }
    var signIn: @Sendable () async throws -> FirebaseAuth.User
    var signOut: @Sendable () async throws -> Void
}

extension AuthClient: DependencyKey {
    static let liveValue = AuthClient(
        authStatePublisher: {
            AsyncStream { continuation in
                let listener = Auth.auth().addStateDidChangeListener { _, user in
                    continuation.yield(user)
                }
            }
        },
        signIn: {
            @MainActor in
            guard let windowScene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first,
                  let window = windowScene.windows.first,
                  let presentingViewController = window.rootViewController else {
                throw GoogleAuthError.noPresentingViewController
            }
            
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController)
            
            guard let idToken = result.user.idToken?.tokenString else {
                throw GoogleAuthError.noIDToken
            }
            
            let accessToken = result.user.accessToken.tokenString
            let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            let authResult = try await Auth.auth().signIn(with: credentials)
            
            return authResult.user
        },
        signOut: {
            GIDSignIn.sharedInstance.signOut()
            try Auth.auth().signOut()
        }
    )
}

extension DependencyValues {
    var authClient: AuthClient {
        get { self[AuthClient.self] }
        set { self[AuthClient.self] = newValue}
    }
}
