//
//  EditProfileView.swift
//  score-ios
//
//  Created by Duru Alaylı on 9/29/26.
//

import SwiftUI

struct EditProfileView: View {

    // MARK: - Properties

    @AppStorage("selectedProfileImage") private var selectedImage = "Blank Profile"
    @ObservedObject private var auth = AuthManager.shared
    var onDone: (() -> Void)?
    private let profileImages = [
        "Blank Profile",
        "Tennis Profile",
        "Baseball Profile",
        "Soccer Profile"
    ]

    // MARK: - UI

    var body: some View {
        VStack(spacing: 60) {
            header
            info
            picSelector
            Spacer()
            buttons
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 60)
        .padding(.top, 32)
    }

    // MARK: - Header

    private var header: some View {
        VStack {
            Text("Edit Profile")
                .font(Constants.Fonts.Header.h1)
                .foregroundStyle(Constants.Colors.primary_gray)
                .frame(maxWidth: .infinity)
            Text("You can change this later in the profile page.")
                .font(Constants.Fonts.medium14)
                .foregroundStyle(Constants.Colors.primary_gray)
                .frame(maxWidth: .infinity)
        }
    }

    // MARK: - Profile

    private var info: some View {
        VStack(spacing: 16) {
            Image(selectedImage)
                .resizable()
                .frame(width: 100, height: 100)
            Text(auth.currentUser?.name ?? "User")
                .font(Constants.Fonts.Header.h3)
                .foregroundStyle(Constants.Colors.black)
                .frame(maxWidth: .infinity)
        }
    }

    private var picSelector: some View {
        VStack(spacing: 24) {
            Text("Select profile picture:")
                .font(Constants.Fonts.medium18)
                .foregroundStyle(Constants.Colors.black)
                .frame(maxWidth: .infinity)
            HStack(spacing: 14) {
                ForEach(profileImages, id: \.self) { name in
                    Button {
                        selectedImage = name
                    } label: {
                        Image(name)
                            .resizable()
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Constants.Colors.green, lineWidth: selectedImage == name ? 4 : 0)
                            )
                    }
                }
            }
        }
    }

    // MARK: - Buttons

    private var buttons: some View {
        VStack(spacing: 16) {
            Button {
                onDone?()
            } label: {
                Text("Next")
                    .font(Constants.Fonts.Header.h3)
                    .foregroundStyle(Constants.Colors.white)
                    .frame(maxWidth: .infinity)
                    .padding(16)
                    .background(Constants.Colors.crimson)
                    .clipShape(Capsule())
            }
            HStack(spacing: 4) {
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundStyle(Constants.Colors.crimson)
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundStyle(Constants.Colors.gray_liner)
            }
        }
    }
}

#Preview {
    EditProfileView()
}
