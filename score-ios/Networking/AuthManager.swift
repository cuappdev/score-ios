//
//  AuthManager.swift
//  score-ios
//
//  Created by Duru Alaylı on 9/29/26.
//

import Foundation

@MainActor
final class AuthManager: ObservableObject {

    // MARK: - Types

    enum AuthResult {
        case existingUser
        case newUser
    }

    // MARK: - Properties

    @Published private(set) var currentUser: User?
    static let shared = AuthManager()
    var accessToken: String? { KeychainHelper.read(KeychainHelper.accessTokenKey) }
    var isSignedIn: Bool { accessToken != nil }
    var hasSkippedSignIn: Bool { UserDefaults.standard.bool(forKey: skippedSignInKey) }
    private let userKey = "currentUser"
    private let skippedSignInKey = "hasSkippedSignIn"

    private init() {
        if let data = UserDefaults.standard.data(forKey: userKey) {
            currentUser = try? JSONDecoder().decode(User.self, from: data)
        }
    }

    // MARK: - Authentication

    func authenticate(idToken: String) async throws -> AuthResult {
        do {
            let login = try await NetworkManager.shared.loginUser(idToken: idToken)
            try saveTokens(access: login.accessToken, refresh: login.refreshToken)
            saveUser(User(
                id: login.user.id,
                email: login.user.email,
                name: login.user.name,
                favoriteTeams: login.user.favoriteTeams.compactMap { $0 }.map {
                    FavoriteTeam(sport: $0.sport, gender: $0.gender)
                }
            ))
            return .existingUser
        } catch NetworkManager.NetworkError.graphQL(let message) where message.contains("User not found") {
            let signup = try await NetworkManager.shared.signupUser(idToken: idToken)
            try saveTokens(access: signup.accessToken, refresh: signup.refreshToken)
            saveUser(User(
                id: signup.user.id,
                email: signup.user.email,
                name: signup.user.name,
                favoriteTeams: signup.user.favoriteTeams.compactMap { $0 }.map {
                    FavoriteTeam(sport: $0.sport, gender: $0.gender)
                }
            ))
            return .newUser
        }
    }

    func signOut() {
        KeychainHelper.delete(KeychainHelper.accessTokenKey)
        KeychainHelper.delete(KeychainHelper.refreshTokenKey)
        currentUser = nil
        UserDefaults.standard.removeObject(forKey: userKey)
    }
    
    func skipSignIn() {
        UserDefaults.standard.set(true, forKey: skippedSignInKey)
    }

    // MARK: - User activities

    func updateFavoriteTeams(_ teams: [FavoriteTeam]) {
        guard let user = currentUser else { return }
        saveUser(User(id: user.id, email: user.email, name: user.name, favoriteTeams: teams))
    }

    // MARK: - Helpers

    private func saveTokens(access: String?, refresh: String?) throws {
        guard let access, let refresh else { throw NetworkManager.NetworkError.noData }
        KeychainHelper.save(access, for: KeychainHelper.accessTokenKey)
        KeychainHelper.save(refresh, for: KeychainHelper.refreshTokenKey)
    }

    private func saveUser(_ user: User) {
        currentUser = user
        if let data = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(data, forKey: userKey)
        }
    }
}
