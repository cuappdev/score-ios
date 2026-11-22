//
//  ProfileVIew.swift
//  score-ios
//
//  Created by Zara Khan on 9/30/26.
//

import SwiftUI

struct ProfileView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var session: AppSession
    @ObservedObject private var auth = AuthManager.shared
    @StateObject private var loginViewModel = LoginViewModel()
    @AppStorage("selectedProfileImage") private var selectedImage = "Blank Profile"
    @State private var showSettings = false
    @State private var showEditSports = false
    @State private var showEditProfile = false
    private var isSignedIn: Bool { auth.currentUser != nil }
    
    // MARK: - UI
    
    var body: some View {
        NavigationStack{
            VStack{
                headerView
                if isSignedIn {
                    profileInfo
                    dividerView
                }
                favoritesView
                dividerView
                bookmarkedHighlights
                Spacer()
            }
            .navigationDestination(isPresented: $showSettings) {
                SettingsView(onReturnToProfile: { showSettings = false })
            }
            .navigationDestination(isPresented: $showEditSports) {
                EditFavSportsView(isOnboarding: false)
            }
            .navigationDestination(isPresented: $showEditProfile) {
                EditProfileView(isOnboarding: false)
            }
            .alert(loginViewModel.errorText, isPresented: $loginViewModel.didPresentError) {
                Button("OK", role: .cancel) {}
            }
        }
    }
    
    // MARK: - Header
    
    private var dividerView: some View {
        Divider()
            .background(Constants.Colors.gray_liner)
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
    }
    
    private var headerView: some View {
        HStack {
            Text("Profile")
                .font(Constants.Fonts.Header.h1)
                .font(Constants.Fonts.semibold24)
                .foregroundStyle(Constants.Colors.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            Button {
                showSettings = true
            } label: {
                Image("Settings")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
        }
        .padding(.top, 20)
        .padding(.horizontal, 20)
    }

    private var profileInfo: some View {
        HStack {
            Image(selectedImage)
                .resizable()
                .frame(width: 70, height: 70)
            VStack {
                Text(auth.currentUser?.name ?? "User")
                    .font(Constants.Fonts.Header.h2)
                    .foregroundStyle(Constants.Colors.primary_gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button {
                    showEditProfile = true
                } label: {
                    Text("Edit Profile Picture")
                        .font(Constants.Fonts.Label.normal)
                        .foregroundStyle(Constants.Colors.crimson)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.top, 2)
            }
            .padding(.horizontal, 5)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    // MARK: - Favorites
    
    private var favoritesView: some View {
        VStack{
            HStack{
                Text("Favorite Sports")
                    .font(Constants.Fonts.Header.h2)
                    .foregroundStyle(Constants.Colors.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button{
                    showEditSports = true
                } label: {
                    HStack(spacing: 2){
                        Text("Edit")
                            .font(Constants.Fonts.Label.normal)
                            .foregroundStyle(auth.favoriteTeams.isEmpty ? Constants.Colors.gray_liner : Constants.Colors.crimson)
                        Image("Arrowhead")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(auth.favoriteTeams.isEmpty ? Constants.Colors.gray_liner : Constants.Colors.crimson)
                            .frame(width: 15, height: 15)
                    }
                }
            }
            .padding(.bottom, 20)
            ScrollViewReader{ proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        if (auth.favoriteTeams.isEmpty) {
                            Button {
                                showEditSports = true
                            } label: {
                                VStack(spacing: 8) {
                                    Image("add")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                        .frame(width: 96, height: 96)
                                        .background(RoundedRectangle(cornerRadius: 28).fill(Color.white))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 28)
                                                .stroke(Color.gray.opacity(0.2), lineWidth: 1.5)
                                        )
                                    Text("Add Sports")
                                        .font(Constants.Fonts.Body.medium)
                                        .foregroundStyle(Constants.Colors.black)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(width: 96)
                            }
                            .buttonStyle(.plain)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        } else {
                            ForEach(auth.favoriteTeams, id: \.self) { team in //will use the articles as filler
                                if let sport = Sport(normalizedValue: team.sport) {
                                    sportIcon(sport: sport, gender: team.gender)
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    private func sportIcon(sport: Sport, gender: String) -> some View {
        VStack(spacing: 8) {
            Image(sport.iconName)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundStyle(Constants.Colors.primary_gray)
                .frame(width: 40, height: 40)
                .frame(width: 96, height: 96)
                .background(RoundedRectangle(cornerRadius: 28).fill(Color.white))
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1.5)
                )
            Text(sport.description)
                .font(Constants.Fonts.Body.medium)
                .foregroundStyle(Constants.Colors.black)
                .multilineTextAlignment(.center)
            HStack(spacing: 4) {
                Image(gender.capitalized == "Womens" ? "tabler_gender-female" : "tabler_gender-male")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 10, height: 10)
                    .frame(width: 18, height: 18)
                    .background(Circle().fill(Constants.Colors.gray_border))
                Text(gender.capitalized == "Womens" ? "W" : "M")
                    .font(Constants.Fonts.Label.normal)
                    .foregroundStyle(Constants.Colors.gray_text)
            }
        }
        .frame(width: 96)
    }
    
    // MARK: - Bookmarked Highlights
    
    private var bookmarkedHighlights: some View {
        VStack {
            HStack {
                Text("Bookmarked Highlights")
                    .font(Constants.Fonts.Header.h2)
                    .foregroundStyle(Constants.Colors.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button {
                    // TODO: show all bookmarked highlights
                } label: {
                    HStack {
                        Text("Show all")
                            .font(Constants.Fonts.Body.medium)
                            .foregroundStyle(isSignedIn ? Constants.Colors.crimson : Constants.Colors.gray_liner)
                        Image(isSignedIn ? "Arrowhead" : "ArrowheadGray")
                            .resizable()
                            .frame(width: 8.23, height: 15.48)
                    }
                }
                .disabled(!isSignedIn)
            }
            .padding(.horizontal, 20)
            if isSignedIn {
                // TODO: show bookmarked highlights
                noBookmarksCard
            } else {
                unlockFeaturesCard
            }
        }
    }

    private var unlockFeaturesCard: some View {
        VStack(spacing: 12) {
            Text("Unlock Features")
                .font(Constants.Fonts.Body.semibold)
                .foregroundStyle(Color.gray)

            (Text("To access these additional features,\nplease ")
                .foregroundColor(Color.gray)
             + Text("log in.")
                .foregroundColor(Constants.Colors.crimson))
                .font(Constants.Fonts.Label.normal)
                .multilineTextAlignment(.center)
            Button {
                logIn()
            } label: {
                Text("Log In")
                    .font(Constants.Fonts.Label.medium)
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 34)
                    .background(Capsule().fill(Constants.Colors.crimson))
            }
            .buttonStyle(.plain)
            .padding(.top, 4)
        }
        .padding(.vertical, 28)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 28).fill(Color.white))
        .overlay(
            RoundedRectangle(cornerRadius: 28)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1.5)
        )
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    private var noBookmarksCard: some View {
        VStack(spacing: 12) {
            Image(systemName: "bookmark.fill")
                .font(.system(size: 16))
                .foregroundStyle(Color(white: 0.75))
                .frame(width: 44, height: 44)
                .background(Circle().fill(Color(white: 0.91)))
            Text("No Bookmarks Yet")
                .font(Constants.Fonts.Body.semibold)
                .foregroundStyle(Color.gray)
            (Text("Go to the ")
                .foregroundColor(Color.gray)
             + Text("Highlights")
                .foregroundColor(Constants.Colors.crimson)
             + Text(" page to\nbegin adding.")
                .foregroundColor(Color.gray))
                .font(Constants.Fonts.Label.normal)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 28)
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1.5)
        )
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    private func logIn() {
        Task {
            switch await loginViewModel.signIn() {
            case .existingUser:
                session.showWelcomeIfSignedIn()
            case .newUser:
                session.showOnboarding = true
            case nil:
                break
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ProfileView()
        .environmentObject(AppSession())
}
