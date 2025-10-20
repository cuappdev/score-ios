//
//  AuthView.swift
//  Center
//
//  Created by Jidong Zheng on 10/19/25.
//

import ComposableArchitecture
import SwiftUI

struct AuthView: View {
    @Bindable var store: StoreOf<AuthFeature>
    
    var body: some View {
        VStack{
            Spacer()
            
            Button(action: { store.send(.signInButtonTapped) }) {
                HStack {
                    if store.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    }
                    Text("Log in with NetID")
                        .foregroundColor(.white)
                }
                .frame(width: 200, height: 50)
                .background(Color.blue)
                .cornerRadius(12)
            }
            .disabled(store.isLoading)
            
            Spacer()
        }
        .padding()
        .alert("Error", isPresented: .constant(store.errorMessage != nil)) {
            Button("OK") {
                store.send(.errorDismissed)
            }
        } message: {
            Text(store.errorMessage ?? "")
        }
    }
}
