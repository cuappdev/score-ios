//
//  NoHighlightView.swift
//  score-ios
//
//  Created by Zain Bilal on 10/15/25.
//

import SwiftUI

struct NoHighlightView: View {
    var body: some View {
        VStack {
            Spacer()
            VStack {
                // TODO: make this image better (higher quality and more accurate colors)
                Image("highlight")
                    .resizable()
                    .frame(width: 100, height: 100, alignment: .center)
                    .tint(Constants.Colors.gray_icons)
                
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

