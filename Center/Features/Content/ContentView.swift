//
//  ContentView.swift
//  Center
//
//  Created by Jidong Zheng on 10/20/25.
//

import ComposableArchitecture
import SwiftUI

struct ContentView: View {
    @Bindable var store: StoreOf<AuthFeature>
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello World!!!")
            
            Button("Sign out") {
                store.send(.signOutbuttonTapped)
            }
        }
        .padding()
    }
}
