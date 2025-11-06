//
//  MainView.swift
//  Center
//
//  Created by Jidong Zheng on 9/26/25.
//

import ComposableArchitecture
import SwiftUI

struct MainView: View {
    @Bindable var store: StoreOf<AppFeature>
    
    var body: some View {
        Group {
            switch store.auth.authState{
            case .authenticated:
                ContentView(store: store.scope(state: \.auth, action: \.auth))
            case .notAuthenticated:
                AuthView(store: store.scope(state: \.auth, action: \.auth))
            }
        }
        .task {
            store.send(.onAppear)
        }
        
    }
}
