//
//  score_iosApp.swift
//  score-ios
//
//  Created by Daniel Chuang on 9/4/24.
//

import SwiftUI
import GoogleSignIn
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct score_iosApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    enum Screen {
        case signIn
        case onboarding
        case main
    }
    enum OnboardingStep {
        case profile
        case favoriteSports
    }
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var session = AppSession()
    @State private var screen: Screen =
        AuthManager.shared.isSignedIn || AuthManager.shared.hasSkippedSignIn ? .main : .signIn
    @State private var onboardingStep: OnboardingStep = .profile
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch screen {
                case .signIn:
                    SignInView(
                        onSignUp: { screen = .onboarding },
                        onLogIn: {
                            session.showWelcomeIfSignedIn()
                            screen = .main
                        },
                        onSignUpLater: {
                            AuthManager.shared.skipSignIn()
                            session.showWelcomeIfSignedIn()
                            screen = .main
                        }
                    )
                case .onboarding:
                    switch onboardingStep {
                    case .profile:
                        EditProfileView(onDone: {
                            withAnimation { onboardingStep = .favoriteSports }
                        })
                        .transition(.push(from: .trailing))
                    case .favoriteSports:
                        EditFavSportsView(onDone: {
                            session.showWelcomeIfSignedIn()
                            screen = .main
                        })
                        .transition(.push(from: .trailing))
                    }
                case .main:
                    ContentView()
                }
            }
            .environmentObject(session)
            .onChange(of: scenePhase) { _, phase in
                session.handleScenePhase(phase)
            }
            .onOpenURL { url in
                GIDSignIn.sharedInstance.handle(url)
            }
        }
    }
}
