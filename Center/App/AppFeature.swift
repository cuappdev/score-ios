//
//  AppFeature.swift
//  Center
//
//  Created by Jidong Zheng on 10/19/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct AppFeature {
    @ObservableState
    struct State: Equatable {
        var auth = AuthFeature.State()
        var isAuthenticated = false
    }
    
    enum Action {
        case auth(AuthFeature.Action)
        case onAppear
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.auth, action: \.auth) {
            AuthFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .auth(.authenticationSucceeded):
                state.isAuthenticated = true
                return .none
                
            case .auth(.authenticationFailed):
                state.isAuthenticated = false
                return .none
                
            case .onAppear:
                return .send(.auth(.startListening))
                
            case .auth:
                return .none
            }
        }
    }
}
