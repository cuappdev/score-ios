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
    // Persisted across launches by Firebase, so it must be set explicitly every time.
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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
