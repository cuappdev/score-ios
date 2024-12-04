//
//  NoGameView.swift
//  score-ios
//
//  Created by Hsia Lu wu on 10/8/24.
//

import SwiftUI

struct NoGameView: View {
    var body: some View {
        VStack {
            Spacer()
            VStack {
               Image("speaker")
                    .resizable()
                    .frame(width: 100, height: 100, alignment: .center)
                Text("No games yet.")
                    .font(Constants.Fonts.bodyBold)
                    .foregroundStyle(Constants.Colors.gray_text)
                Text("Check back here later")
                    .font(Constants.Fonts.caption)
                    .foregroundStyle(Constants.Colors.gray_text)
                    .padding(.top, 2)
            }
//            Spacer()
            Spacer()
        }
    }
}

#Preview {
    NoGameView()
}
