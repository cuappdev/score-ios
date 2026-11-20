//
//  NoFavoritesBanner.swift
//  score-ios
//
//  Created by Duru Alaylı on 11/18/26.
//

import SwiftUI

struct NoFavoritesBanner: View {
    
    @EnvironmentObject private var session: AppSession
    
    var body: some View {
        HStack (spacing: 12) {
            VStack (alignment: .leading, spacing: 4) {
                Text("Showing all sports.")
                    .font(Constants.Fonts.semibold18)
                    .foregroundStyle(Constants.Colors.white)
                Text("Select your favorite sports to personalize your feed.")
                    .font(Constants.Fonts.Label.normal)
                    .foregroundStyle(Constants.Colors.white)
            }
            Spacer()
            Button {
                session.selectedTab = .profiles
            } label: {
                HStack (spacing: 0) {
                    Text("Go to Profile")
                        .font(Constants.Fonts.Label.medium)
                        .foregroundStyle(Constants.Colors.white)
                    Image("Arrowhead")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Constants.Colors.white)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .overlay(
                        Capsule()
                            .stroke(Constants.Colors.white, lineWidth: 1)
                    )
                }
                .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(
            LinearGradient(
                colors: [
                    Constants.Colors.light_red,
                    Constants.Colors.dark_red
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.16), radius: 5, x: 0, y: 6)
    }
}

#Preview {
    NoFavoritesBanner()
}
