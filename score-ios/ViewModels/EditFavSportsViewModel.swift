//
//  EditFavSportsViewModel.swift
//  score-ios
//
//  Created by Duru Alaylı on 10/7/26.
//

import SwiftUI

@MainActor
final class EditFavSportsViewModel: ObservableObject {

    // MARK: - Properties

    @Published private(set) var selected: Set<FavoriteTeam> = []
    @Published private(set) var savedFavorites: Set<FavoriteTeam> = []
    @Published private(set) var isSaving = false
    @Published var showError = false

    // MARK: - Selection

    func loadFavorites() {
        savedFavorites = Set(AuthManager.shared.favoriteTeams)
        selected = savedFavorites
    }

    func isSelected(_ team: FavoriteTeam) -> Bool {
        selected.contains(team)
    }

    func toggle(_ team: FavoriteTeam) {
        if selected.contains(team) {
            selected.remove(team)
        } else {
            selected.insert(team)
        }
    }

    // MARK: - Saving

    func saveFavorites() async -> Bool {
        guard AuthManager.shared.currentUser != nil else {
            AuthManager.shared.saveLocalFavoriteTeams(Array(selected))
            return true
        }
        isSaving = true
        defer { isSaving = false }
        let original = Set(AuthManager.shared.currentUser?.favoriteTeams ?? [])
        var saved = original
        defer { AuthManager.shared.updateFavoriteTeams(Array(saved)) }
        do {
            for team in selected.subtracting(original) {
                try await NetworkManager.shared.addFavoriteTeam(sport: team.sport, gender: team.gender)
                saved.insert(team)
            }
            for team in original.subtracting(selected) {
                try await NetworkManager.shared.removeFavoriteTeam(sport: team.sport, gender: team.gender)
                saved.remove(team)
            }
            return true
        } catch {
            showError = true
            return false
        }
    }
}
