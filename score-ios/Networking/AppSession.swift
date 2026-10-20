//
//  AppSession.swift
//  score-ios
//
//  Created by Duru Alaylı on 10/7/26.
//

import SwiftUI

@MainActor
final class AppSession: ObservableObject {

    // MARK: - Properties

    @Published private(set) var openCount = 1
    @Published private(set) var showWelcome = AuthManager.shared.currentUser != nil
    private var wasInBackground = false

    // MARK: - App Lifecycle

    func handleScenePhase(_ phase: ScenePhase) {
        switch phase {
        case .background:
            wasInBackground = true
        case .active where wasInBackground:
            wasInBackground = false
            showWelcomeIfSignedIn()
            openCount += 1
        default:
            break
        }
    }

    // MARK: - Welcome Banner

    func showWelcomeIfSignedIn() {
        showWelcome = AuthManager.shared.currentUser != nil
    }

    func dismissWelcome() {
        showWelcome = false
    }
}
