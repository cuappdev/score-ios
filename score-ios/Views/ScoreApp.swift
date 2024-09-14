//
//  ContentView.swift
//  score-ios
//
//  Created by Daniel Chuang on 9/4/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedSex : Sex = .Both
    
    var body: some View {
        VStack {
            // Sex selector
            PickerView()
            
            // Sport selector
            
            // List of games
        }
        .padding()
    }
}

#Preview {
    PickerView()
}
