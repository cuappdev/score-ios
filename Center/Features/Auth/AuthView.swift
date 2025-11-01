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
            
            Image("AppLogo")
            
            Text("Welcome to Hustle")
                .foregroundColor(DesignConstants.Colors.white)
                .font(DesignConstants.Fonts.h1)
            
            Text("Browse. Buy. Book")
                .foregroundColor(DesignConstants.Colors.white)
                .font(DesignConstants.Fonts.title1)
            
            Spacer()
            
            Button(action: { store.send(.signInButtonTapped) }) {
                HStack {
                    Text("Log in with NetID")
                        .foregroundColor(DesignConstants.Colors.hustleGreen)
                        .font(DesignConstants.Fonts.title1)
                }
                .frame(width: 326, height: 51)
                .background(DesignConstants.Colors.accentGreen)
                .cornerRadius(15)
            }
            .disabled(store.isLoading)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(DesignConstants.Colors.hustleGreen)
    }
    
}
