//
//  ProfileVIew.swift
//  score-ios
//
//  Created by Zara Khan on 9/30/26.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: HighlightsViewModel //will implement later
    @AppStorage("selectedProfileImage") private var selectedImage = "Blank Profile"
    @State private var showSettings = false
    @State private var showEditSports = false
    @State private var showEditProfileView = false
    //private var highlights: [Highlight] { viewModel.allHighlights}
    @ObservedObject private var auth = AuthManager.shared
    
    var body: some View {
        NavigationStack{
            VStack{
                headerView
                dividerView
                favortiesView
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
            .navigationDestination(isPresented: $showEditProfileView) {
                EditProfileView(isOnboarding: false)
            }
        }
    }
    
    
    private var dividerView: some View {
        Divider()
            .background(Constants.Colors.gray_liner)
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
    }
    
    private var headerView: some View {
        Group{
            VStack {
                HStack{
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
            HStack{
                Image(selectedImage)
                    .resizable()
                    .frame(width: 70, height: 70)
                VStack{
                    Text(auth.currentUser?.name ?? "User")
                        .font(Constants.Fonts.Header.h2)
                        .foregroundStyle(Constants.Colors.primary_gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Button{
                        showEditProfileView = true
                    } label: {
                        Text("Edit Profile Picture")
                            .font(Constants.Fonts.Label.normal)
                            .foregroundStyle(Constants.Colors.crimson)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.top,2)
                }
                .padding(.horizontal, 5)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
    }
    
    private var favortiesView: some View {
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
                                    makeSPortIcon(sport: sport, gender: team.gender)
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    private func makeSPortIcon(sport: Sport, gender: String) -> some View {
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
    
    private var bookmarkedHighlights: some View {
        VStack{
            HStack{
                Text("Bookmarked Highlights")
                    .font(Constants.Fonts.Header.h2)
                    .foregroundStyle(Constants.Colors.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button{
                    // do nothing rn
                } label: {
                    HStack{
                        Text("Show all")
                            .font(Constants.Fonts.Body.medium)
                            .foregroundStyle(Constants.Colors.crimson)
                        Image("Arrowhead")
                            .resizable()
                            .frame(width: 8.23, height: 15.48)
                    }
                }
            }
            .padding(.horizontal, 20)
            ScrollView(.horizontal, showsIndicators: false) {
                //LazyHStack(spacing: 20) {
                    //ForEach(highlights) { highlight in
                        //HighlightTile(highlight: highlight, isVertical: false)
                    //}
               // }
                //.padding(.horizontal, 20)
            }
            .fixedSize(horizontal: false, vertical: true)
            .task {
                  // await viewModel.loadHighlights()
               }
                    .padding(.top, 20)
                    .font(Constants.Fonts.medium18)
            }
        }
    }



// MARK: - Preview

#Preview {
    ProfileView()
        .environmentObject(HighlightsViewModel.shared) //need to change vm
}
