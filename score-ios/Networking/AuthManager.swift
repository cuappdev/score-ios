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

    static let shared = AuthManager()
    @Published private(set) var currentUser: User?
    var accessToken: String? { KeychainHelper.read(KeychainHelper.accessTokenKey) }
    var isSignedIn: Bool { accessToken != nil }
    var hasSkippedSignIn: Bool { UserDefaults.standard.bool(forKey: skippedSignInKey) }
    private let userKey = "currentUser"
    private let localFavoritesKey = "localFavoriteTeams"
    private let skippedSignInKey = "hasSkippedSignIn"
    private var isUploadingFavorites = false

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
                },
                bookmarkedHighlightIds: login.user.bookmarkedHighlightIds.compactMap { $0 }
            ))
            await uploadLocalFavorites()
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
                },
                bookmarkedHighlightIds: signup.user.bookmarkedHighlightIds.compactMap { $0 }
            ))
            await uploadLocalFavorites()
            return .newUser
        }
    }
    
    func logOut() async {
        try? await NetworkManager.shared.logoutUser()
        clearSession()
        skipSignIn()
    }
    
    func deleteAccount() async throws {
        try await NetworkManager.shared.deleteUser()
        clearSession()
        skipSignIn()
    }
    
    func skipSignIn() {
        UserDefaults.standard.set(true, forKey: skippedSignInKey)
    }
    
    func refreshAccessToken() async throws {
        do {
            let token = try await NetworkManager.shared.refreshAccessToken()
            KeychainHelper.save(token, for: KeychainHelper.accessTokenKey)
        } catch {
            clearSession()
            throw error
        }
    }

    // MARK: - User activities

    func updateFavoriteTeams(_ teams: [FavoriteTeam]) {
        guard let user = currentUser else { return }
        saveUser(User(
            id: user.id,
            email: user.email,
            name: user.name,
            favoriteTeams: teams,
            bookmarkedHighlightIds: user.bookmarkedHighlightIds
        ))
    }

    func updateBookmarkedHighlightIds(_ ids: [String]) {
        guard let user = currentUser else { return }
        saveUser(User(
            id: user.id,
            email: user.email,
            name: user.name,
            favoriteTeams: user.favoriteTeams,
            bookmarkedHighlightIds: ids
        ))
    }
    
    var favoriteTeams: [FavoriteTeam] {
        guard let user = currentUser else { return localFavoriteTeams }
        return user.favoriteTeams + localFavoriteTeams.filter { !user.favoriteTeams.contains($0) }
    }

    private var localFavoriteTeams: [FavoriteTeam] {
        guard let data = UserDefaults.standard.data(forKey: localFavoritesKey) else { return [] }
        return (try? JSONDecoder().decode([FavoriteTeam].self, from: data)) ?? []
    }

    func saveLocalFavoriteTeams(_ teams: [FavoriteTeam]) {
        if let data = try? JSONEncoder().encode(teams) {
            UserDefaults.standard.set(data, forKey: localFavoritesKey)
        }
        objectWillChange.send()
    }
    
    func uploadLocalFavorites() async {
        guard !isUploadingFavorites else { return }
        isUploadingFavorites = true
        defer { isUploadingFavorites = false }
        let local = Set(localFavoriteTeams)
        guard !local.isEmpty, let user = currentUser else { return }
        var teams = Set(user.favoriteTeams)
        var failed: [FavoriteTeam] = []
        for team in local.subtracting(teams) {
            do {
                try await NetworkManager.shared.addFavoriteTeam(sport: team.sport, gender: team.gender)
                teams.insert(team)
            } catch {
                failed.append(team)
            }
        }
        updateFavoriteTeams(Array(teams))
        if failed.isEmpty {
            UserDefaults.standard.removeObject(forKey: localFavoritesKey)
        } else {
            saveLocalFavoriteTeams(failed)
        }
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
    
    private func clearSession() {
        KeychainHelper.delete(KeychainHelper.accessTokenKey)
        KeychainHelper.delete(KeychainHelper.refreshTokenKey)
        currentUser = nil
        UserDefaults.standard.removeObject(forKey: userKey)
        UserDefaults.standard.removeObject(forKey: localFavoritesKey)
    }
}
