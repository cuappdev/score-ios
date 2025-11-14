//
//  NoHighlightView.swift
//  score-ios
//
//  Created by Zain Bilal on 11/5/25.
//

import SwiftUI

struct NoHighlightView: View {
    var body: some View {
        VStack {
            Spacer()
            VStack {
               Image("HighlightStar")
                    .resizable()
                    .frame(width: 100, height: 100, alignment: .center)
                
                Text("No results yet.")
                    .font(Constants.Fonts.bodyBold)
                    .foregroundStyle(Constants.Colors.gray_text)
                
                Text("Check back here later!")
                    .font(Constants.Fonts.caption)
                    .foregroundStyle(Constants.Colors.gray_text)
            }
            Spacer()
        }
    }
}

#Preview {
    NoHighlightView()
}
