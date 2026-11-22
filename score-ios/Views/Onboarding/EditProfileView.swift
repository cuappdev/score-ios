//
//  EditProfileView.swift
//  score-ios
//
//  Created by Duru Alaylı on 9/29/26.
//

import SwiftUI

struct EditProfileView: View {

    // MARK: - Properties

    var onDone: (() -> Void)?
    var isOnboarding = true
    @AppStorage("selectedProfileImage") private var selectedImage = "Blank Profile"
    @ObservedObject private var auth = AuthManager.shared
    @Environment(\.dismiss) private var dismiss
    @State private var showBanner = false
    private let profileImages = [
        "Blank Profile",
        "Tennis Profile",
        "Baseball Profile",
        "Soccer Profile"
    ]

    // MARK: - UI

    var body: some View {
        VStack(spacing: 0) {
            if !isOnboarding {
                navigationHeader
            }
            VStack(spacing: 60) {
                if isOnboarding {
                    header
                }
                info
                picSelector
                Spacer()
                if isOnboarding {
                    buttons
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 60)
            .padding(.top, 32)
            .overlay(alignment: .top) {
                if showBanner {
                    banner
                        .padding(.top, 16)
                        .padding(.horizontal, 24)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        .onChange(of: selectedImage) {
            guard !isOnboarding else { return }
            withAnimation { showBanner = true }
        }
        .task(id: showBanner) {
            guard showBanner else { return }
            try? await Task.sleep(for: .seconds(2))
            withAnimation { showBanner = false }
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack {
            Text("Edit Profile")
                .font(Constants.Fonts.Header.h1)
                .foregroundStyle(Constants.Colors.primary_gray)
                .frame(maxWidth: .infinity)
            Text("You can change this later in the profile page.")
                .font(Constants.Fonts.regular14)
                .foregroundStyle(Constants.Colors.primary_gray)
                .frame(maxWidth: .infinity)
        }
    }
    
    private var navigationHeader: some View {
        ZStack {
            Text("Edit Profile")
                .font(Constants.Fonts.medium18)
                .foregroundStyle(Constants.Colors.black)
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image("arrow_back_ios")
                        .resizable()
                        .frame(width: 9.87, height: 18.57)
                }
                Spacer()
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(Constants.Colors.white)
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
        .zIndex(1)
    }

    // MARK: - Profile

    private var info: some View {
        VStack(spacing: 16) {
            Image(selectedImage)
                .resizable()
                .frame(width: 100, height: 100)
            if isOnboarding {
                Text(auth.currentUser?.name ?? "User")
                    .font(Constants.Fonts.Header.h3)
                    .foregroundStyle(Constants.Colors.black)
                    .frame(maxWidth: .infinity)
            }
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
    
    // MARK: - Success Banner
    
    private var banner: some View {
        HStack(spacing: 8) {
            Image("check_circle")
                .resizable()
                .frame(width: 32, height: 32)
            Text("Your changes have been saved")
                .font(Constants.Fonts.Body.medium)
                .foregroundStyle(Constants.Colors.white)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Constants.Colors.crimson)
        )
    }
}

#Preview {
    EditProfileView()
}
