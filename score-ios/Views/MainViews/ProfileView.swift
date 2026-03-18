//
//  ProfileView.swift
//  score-ios
//
//  Created by Duru Alaylı on 2/19/26.
//

import SwiftUI

struct ProfileView: View {
    
    // MARK: - Properties
    @StateObject var profileViewModel = ProfileViewModel.shared
    @Environment(\.dismiss) private var dismiss
    @State private var isSheet = false
    @State private var isEdit = false
    @State private var editedName: String = ""
    @State private var editedUsername: String = ""
    @State private var editedImage: String = ""
    
    // MARK: - UI
    var body: some View {
            ScrollView {
                VStack (spacing: 24) {
                    header
                    profileNameSection
                    bookmarksSection
                    likedGamesSection
                }
            }
            .navigationDestination(isPresented: $isEdit) {
                editProfileView
            }
    }
    
    private var header: some View {
        HStack (spacing: 8) {
            Text ("Profile")
                .font(Constants.Fonts.Header.h1)
                .foregroundStyle(Constants.Colors.primary_gray)
            Spacer()
            HStack {
                Button(action: {
                    // TODO: notifications button
                }) {
                    Image ("notifications")
                        .resizable()
                        .frame(width: 27,height: 27)
                }
                Button(action: {
                    // TODO: three lines button
                }) {
                    Image ("dehaze")
                        .resizable()
                        .frame(width: 24,height: 24)
                }
            }
        }
        .padding(.horizontal,24)
    }
    
    private var profileNameSection: some View {
        HStack (spacing: 18){
            Image (profileViewModel.user.profileImage)
                    .resizable()
                    .frame(width: 124,height: 124)
            
            VStack (alignment: .leading){
                Text (profileViewModel.user.name)
                    .font(Constants.Fonts.semibold18)
                    .foregroundStyle(Constants.Colors.primary_gray)
                Text (profileViewModel.user.username)
                    .font(Constants.Fonts.medium18)
                    .foregroundStyle(Constants.Colors.primary_gray)
                Button(action: {
                    isEdit = true
                }) {
                    Text ("Edit profile")
                        .font(Constants.Fonts.Body.normal)
                        .foregroundStyle(Constants.Colors.primary_gray)
                        .padding(.horizontal,12)
                        .padding(.vertical,4)
                        .background(
                            RoundedRectangle(cornerRadius: 100)
                                .stroke(Constants.Colors.gray_border, lineWidth: 1)
                        )
                }
            }
            Spacer()
        }
        .padding(.horizontal, 24)
    }
    
    private var bookmarksSection: some View {
        VStack (spacing: 16){
            HStack {
                Text ("Bookmarks")
                    .font(Constants.Fonts.Header.h2)
                    .foregroundStyle(Constants.Colors.primary_gray)
                Spacer()
                Text ("4 Results")
                    .font(Constants.Fonts.Body.normal)
                    .foregroundStyle(Constants.Colors.gray_icons)
                Button(action: {
                    // TODO: all bookmarks button
                }) {
                    Image ("Arrowhead")
                        .resizable()
                        .frame(width: 20,height: 20)
                }
            }
            ScrollView(.horizontal) {
                LazyHStack (spacing: 16){
                    bookmarkGameCard
                    bookmarkGameCard
                    bookmarkGameCard
                    bookmarkGameCard
                    bookmarkGameCard
                }
            }
        }
        .padding(.horizontal,24)
    }
    
    private var likedGamesSection: some View {
        VStack (spacing: 16){
            HStack {
                Text ("Games You Might Like")
                    .font(Constants.Fonts.Header.h2)
                    .foregroundStyle(Constants.Colors.primary_gray)
                Spacer()
                Text ("4 Results")
                    .font(Constants.Fonts.Body.normal)
                    .foregroundStyle(Constants.Colors.gray_icons)
                Button(action: {
                    // TODO: all games like button
                }) {
                    Image ("Arrowhead")
                        .resizable()
                        .frame(width: 20,height: 20)
                }
            }
            ScrollView(.horizontal) {
                LazyHStack (spacing: 16){
                    bookmarkGameCard
                    bookmarkGameCard
                    bookmarkGameCard
                    bookmarkGameCard
                    bookmarkGameCard
                }
            }
        }
        .padding(.horizontal, 24)
    }
    
    private var bookmarkGameCard: some View {
        Button(action: {
            // TODO: settings button
        }) {
            VStack (spacing: 8){
                Image ("BookmarkGame")
                    .resizable()
                    .frame(height: 116)
                VStack {
                    HStack {
                        Text ("Cornell vs. Columbia")
                            .font(Constants.Fonts.Header.h2)
                            .foregroundStyle(Constants.Colors.black)
                        Spacer()
                    }
                    HStack {
                        Image ("Soccer-g")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Image ("Men's-g")
                            .resizable()
                            .frame(width: 19, height: 19)
                        Spacer()
                        Text ("11/09")
                            .font(Constants.Fonts.Label.normal)
                            .foregroundStyle(Constants.Colors.gray_icons)
                        
                    }
                    .padding(.bottom, 8)
                }
                .padding(.horizontal, 16)
            }
            .background(Constants.Colors.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Constants.Colors.gray_border, lineWidth: 1)
                    .shadow(radius: 5)
            )
            .padding(.vertical, 10)
        }
    }
    
    
    private var editProfileView: some View {
        VStack (spacing: 48){
            Divider()
            VStack (spacing: 16){
                Image (profileViewModel.user.profileImage)
                    .resizable()
                    .frame(width: 120,height: 120)
                Button(action: {
                    isSheet.toggle()
                }) {
                    Text ("Edit photo")
                        .font(Constants.Fonts.semibold18)
                        .foregroundStyle(Constants.Colors.primary_red)
                }
                .sheet(isPresented: $isSheet) {
                    imageChooserView
                        .presentationDetents([.fraction(0.75)])
                        .presentationBackground(.white)
                }
            }
            VStack (spacing: 24) {
                HStack {
                    Text ("Name")
                        .font(Constants.Fonts.semibold18)
                        .foregroundStyle(Constants.Colors.primary_gray)
                    Spacer()
                    TextField (profileViewModel.user.name, text: $editedName)
                        .multilineTextAlignment(.trailing)
                        .font(Constants.Fonts.Header.h2)
                        .foregroundStyle(Constants.Colors.primary_gray)
                }
                HStack {
                    Text ("Username")
                        .font(Constants.Fonts.semibold18)
                        .foregroundStyle(Constants.Colors.primary_gray)
                    Spacer()
                    TextField (profileViewModel.user.username, text: $editedUsername)
                        .multilineTextAlignment(.trailing)
                        .font(Constants.Fonts.Header.h2)
                        .foregroundStyle(Constants.Colors.primary_gray)
                }
            }
            .padding(.horizontal, 24)
            Spacer()
            Button(action: {
                profileViewModel.saveUser(
                    name: editedName,
                    username: editedUsername,
                    profileImage: editedImage
                )
                isEdit = false
            }) {
                Text ("Save")
                    .font(Constants.Fonts.Header.h1)
                    .foregroundStyle(Constants.Colors.white)
                    .padding(.horizontal,40)
                    .padding(.vertical,8)
                    .background(
                        RoundedRectangle(cornerRadius: 50)
                            .fill(Constants.Colors.primary_red)
                    )
            }
            .onAppear {
                editedName = profileViewModel.user.name
                editedUsername = profileViewModel.user.username
                editedImage = profileViewModel.user.profileImage
                }
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var imageChooserView: some View {
        VStack (spacing: 12){
            let profile_picture = (0...11).map { "profile\($0)" }
            
            let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 3)
            HStack {
                Button(action: {
                    isSheet.toggle()
                }) {
                    Image ("cross")
                        .resizable()
                        .frame(width: 13,height: 13)
                        .padding(.horizontal,15)
                        .padding(.vertical,5.6)
                        .background(
                            Circle()
                                .fill(Constants.Colors.gray_liner)
                        )
                }
                Spacer()
            }
            LazyVGrid (columns: columns, spacing: 14) {
                ForEach(profile_picture, id: \.self) { profile in
                    Button(action: {
                        editedImage = profile
                    }) {ZStack {
                        Image (profile)
                            .resizable()
                            .frame(width: 100,height: 100)
                            .opacity(editedImage == profile ? 0.5 : 1)
                        if editedImage == profile {
                            Image ("check")
                                .resizable()
                                .frame(width: 32,height: 24)
                        }
                    }
                    }
                }
            }
            Button(action: {
                profileViewModel.saveUser(
                    name: editedName,
                    username: editedUsername,
                    profileImage: editedImage
                )
                isSheet.toggle()
            }) {
            Text ("Save")
                .font(Constants.Fonts.Header.h1)
                .foregroundStyle(Constants.Colors.white)
                .padding(.horizontal,40)
                .padding(.vertical,8)
                .background(
                    RoundedRectangle(cornerRadius: 50)
                        .fill(editedImage != profileViewModel.user.profileImage ? Constants.Colors.primary_red : Constants.Colors.gray_liner)
                )
            }
        }
        .padding(.horizontal,16)
        .onAppear {
            editedImage = profileViewModel.user.profileImage
        }
    }
}
    
// MARK: - Preview
#Preview {
    ProfileView()
}
