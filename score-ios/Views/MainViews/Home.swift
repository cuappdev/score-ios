//
//  score_iosApp.swift
//  score-ios
//
//  Created by Daniel Chuang on 9/4/24.
//

import SwiftUI
import FirebaseAnalytics
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
#if DEBUG
    Analytics.setAnalyticsCollectionEnabled(ProcessInfo.processInfo.arguments.contains("-FIRDebugEnabled"))
#else
    Analytics.setAnalyticsCollectionEnabled(true)
#endif
    return true
  }
}

@main
struct score_iosApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onChange(of: scenePhase) { _, phase in
                    switch phase {
                    case .background: LiveGameStore.shared.suspend()
                    case .active: LiveGameStore.shared.resume()
                    default: break
                    }
                }
        }
    }
}
