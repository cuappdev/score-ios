//
//  TopHeader.swift
//  score-ios
//
//  Created by Duru Alaylı on 3/18/26.
//

import SwiftUI

struct TopHeader: View {
    let title: String
    let onProfileTap: () -> Void

    var body: some View {
        HStack {
            Text(title)
                .font(Constants.Fonts.semibold24)

            Spacer()

            Button {
                // notifications
            } label: {
                Image("notifications")
                    .resizable()
                    .frame(width: 36, height: 36)
            }

            Button {
                onProfileTap()
            } label: {
                Image("profile")
                    .resizable()
                    .frame(width: 28, height: 28)
            }
        }
        .padding(.top, 24)
        .background(Color.white)
    }
}
