//
//  FontDebugView.swift
//  score-ios
//
//  Created by Mac User on 2/12/25.
//

// TODO: Delete this after Dev Feedback updates
// Finding that the fonts in resources aren't actually in the project, hence the issue with semi-bold!

import SwiftUI

struct FontDebugView: View {
    var body: some View {
        Text("Check Console for Fonts")
            .onAppear {
                print("Printing fonts")
                for family in UIFont.familyNames {
                    print("Family: \(family)")
                    for fontName in UIFont.fontNames(forFamilyName: family) {
                        print("   Font: \(fontName)")
                    }
                }
            }
    }
}

#Preview {
    FontDebugView()
}
