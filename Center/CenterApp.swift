//
//  CenterApp.swift
//  Center
//
//  Created by Peter Bidoshi on 9/10/25.
//

import SwiftUI
import ComposableArchitecture

@main
struct CenterApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    let store = Store(initialState: AppFeature.State()) {
        AppFeature()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView(store: store)
        }
    }
}
