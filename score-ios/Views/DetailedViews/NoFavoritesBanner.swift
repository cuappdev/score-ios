//
//  NoFavoritesBanner.swift
//  score-ios
//
//  Created by Duru Alaylı on 11/18/26.
//

import SwiftUI

struct NoFavoritesBanner: View {

    // MARK: - Properties

    @EnvironmentObject private var session: AppSession

    // MARK: - UI

    var body: some View {
        HStack(spacing: 12) {
            message
            Spacer(minLength: 0)
            profileButton
        }
        .foregroundStyle(Constants.Colors.white)
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(gradient)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.16), radius: 5, x: 0, y: 6)
    }
    
    // MARK: - Contents

    private var message: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Showing all sports.")
                .font(Constants.Fonts.semibold18)
            Text("Select your favorite sports to personalize your feed.")
                .font(Constants.Fonts.Label.normal)
        }
    }

    private var profileButton: some View {
        Button {
            session.selectedTab = .profiles
        } label: {
            HStack(spacing: 0) {
                Text("Go to Profile")
                    .font(Constants.Fonts.Label.medium)
                Image("Arrowhead")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 20, height: 20)
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

    private var gradient: LinearGradient {
        LinearGradient(
            colors: [
                Constants.Colors.light_red,
                Constants.Colors.dark_red
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

#Preview {
    NoFavoritesBanner()
        .environmentObject(AppSession())
}
