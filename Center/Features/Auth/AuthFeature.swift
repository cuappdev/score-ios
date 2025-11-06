//
//  AuthFeature.swift
//  Center
//
//  Created by Jidong Zheng on 10/19/25.
//

import ComposableArchitecture
import FirebaseAuth
import GoogleSignIn

public enum AuthState {
    case authenticated, notAuthenticated
}

@Reducer
struct AuthFeature {
    @ObservableState
    struct State: Equatable {
        var authState: AuthState = .notAuthenticated
        var user: FirebaseAuth.User?
        var isLoading = false
        var errorMessage: String?
    }
    
    enum Action: Equatable {
        case startListening
        case signInButtonTapped
        case signOutbuttonTapped
        case authenticationSucceeded(FirebaseAuth.User)
        case authenticationFailed
        case signInSucceeded(FirebaseAuth.User)
        case signInFailed(String)
        case signOutSucceeded
        case signOutFailed(String)
        case errorDismissed
    }
    
    @Dependency(\.authClient) var authClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .startListening:
                return .run { send in
                    if let currentUser = Auth.auth().currentUser {
                        await send(.authenticationSucceeded(currentUser))
                    } else {
                        await send(.authenticationFailed)
                    }
                    
                    for await user in authClient.authStatePublisher() {
                        if let user = user {
                            await send(.authenticationSucceeded(user))
                        } else {
                            await send(.authenticationFailed)
                        }
                    }
                }
            case .signInButtonTapped:
                state.isLoading = true
                state.errorMessage = nil
                return .run { send in
                    do {
                        let user = try await authClient.signIn()
                        await send(.signInSucceeded(user))
                    } catch {
                        await send(.signInFailed(error.localizedDescription))
                    }
                }
            case .signOutbuttonTapped:
                state.isLoading = true
                return .run { send in
                    do {
                        try await authClient.signOut()
                        await send(.signOutSucceeded)
                    } catch {
                        await send(.signOutFailed(error.localizedDescription))
                    }
                    
                }
                
            case let .authenticationSucceeded(user):
                state.authState = .authenticated
                state.user = user
                state.isLoading = false
                return .none
                
            case .authenticationFailed:
                state.authState = .notAuthenticated
                state.user = nil
                state.isLoading = false
                return .none
                
            case let .signInSucceeded(user):
                state.authState = .authenticated
                state.user = user
                state.isLoading = false
                return .none
                
            case let .signInFailed(errorMessage):
                state.isLoading = false
                state.errorMessage = errorMessage
                return .none
                
            case .signOutSucceeded:
                state.authState = .notAuthenticated
                state.user = nil
                state.isLoading = false
                return .none
                
            case let .signOutFailed(errorMessage):
                state.isLoading = false
                state.errorMessage = errorMessage
                return .none
                
            case .errorDismissed:
                state.errorMessage = nil
                return .none
                
                
            }
            
        }
    }
}

