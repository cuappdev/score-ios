//
//  ProfileVIew.swift
//  score-ios
//
//  Created by Zara Khan on 9/30/26.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: HighlightsViewModel //will implement later
    private var highlights: [Highlight] { viewModel.allHighlights}
    
    var body: some View {
        NavigationStack{
            VStack{
                headerView
                dividerView
                favortiesView
                dividerView
                bookmarkedHighlights
            }
        }
    }
    
    
    var dividerView: some View {
        Divider()
               .background(Constants.Colors.gray_liner)
               .frame(width: 345, height: 0)
    }
    
    var headerView: some View {
        Group{
            VStack {
                HStack{
                    Text("Profile")
                        .font(Constants.Fonts.Header.h1)
                        .font(Constants.Fonts.semibold24)
                        .foregroundStyle(Constants.Colors.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 24)
                        .padding(.horizontal, 24)
                    Button{
                        // do nothing rn
                    } label: {
                        Image("Notifications")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    Button{
                        // do nothing rn
                    } label: {
                        Image("Settings")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding(.horizontal, 20)
                    }
                }
            }
            HStack{
                Image("Tennis Profile")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .padding(.horizontal, 20)
                Spacer()
                VStack{
                    Text("Zara Khan")
                        .font(Constants.Fonts.Header.h2)
                        .foregroundStyle(Constants.Colors.gray_text)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Button{
                        // do nothing rn
                    } label: {
                        Text("Edit Profile Picture")
                            .font(Constants.Fonts.Label.normal)
                            .foregroundStyle(Constants.Colors.crimson)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
    }
    
    var favortiesView: some View {
        VStack{
            HStack{
                Text("Favorite Sports")
                    .font(Constants.Fonts.Header.h2)
                    .foregroundStyle(Constants.Colors.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                Button{
                    // do nothing rn
                } label: {
                    HStack{
                        Text("Edit")
                            .font(Constants.Fonts.Label.normal)
                            .foregroundStyle(Constants.Colors.crimson)
                            .padding(.top, 24)
                        Image("Arrowhead")
                            .resizable()
                            .frame(width: 8.23, height: 15.48)
                            .padding(.top, 24)
                    }
                    .padding(.horizontal, 20)
                }
            }
            ScrollViewReader{ proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(Sport.allCases) { sport in //will use the articles as filler?
                            makeSPortIcon(sport: sport)
                            
                        }
                    }
                }
            }
        }
    }
    
    private func makeSPortIcon(sport: Sport) -> some View {
        VStack{
            Image(sport.description + "-g")
                .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)          // icon size
                        .frame(width: 96, height: 96)          // card size
                        .background(
                            RoundedRectangle(cornerRadius: 28)
                                .fill(Color.white)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 28)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1.5)
                        )
            Text(sport.description)
                .font(Constants.Fonts.Body.medium)
                .foregroundStyle(Constants.Colors.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 24)
            HStack{
                Image("tabler_gender-female") //arb. genger
                    .background(
                        Circle()
                            .fill(Constants.Colors.gray_border)
                            .frame(width: 18, height: 18)
                    )
                Text("W")
                
            }
        }
    }
    
    var bookmarkedHighlights: some View {
        VStack{
            HStack{
                Text("Bookmarked Highlights")
                    .font(Constants.Fonts.Header.h2)
                    .foregroundStyle(Constants.Colors.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)

                Button{
                    // do nothing rn
                } label: {
                    HStack{
                        Text("Show all")
                            .font(Constants.Fonts.Label.normal)
                            .foregroundStyle(Constants.Colors.crimson)
                            .padding(.top, 24)
                        Image("Arrowhead")
                            .resizable()
                            .frame(width: 8.23, height: 15.48)
                            .padding(.top, 24)
                    }
                }
            }
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 24) {
                    ForEach(highlights) { highlight in
                        HighlightTile(highlight: highlight, isVertical: false)
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal, 24)
            }
            .task {
                   viewModel.loadHighlights()
               }
                    .padding(.top, 24)
                    .padding(.horizontal, 24)
                    .font(Constants.Fonts.medium18)
            }
        }
    }
}


// MARK: - Preview

#Preview {
    ProfileView()
        .environmentObject(HighlightsViewModel.shared) //need to change vm
}
