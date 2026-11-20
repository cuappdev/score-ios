//
//  NonSignedInProfileView.swift
//  score-ios
//
//  Created by Zara Khan on 11/11/26.
//


import SwiftUI

struct NonSignedInProfileView: View {
    @EnvironmentObject var viewModel: HighlightsViewModel //will implement later
    private var highlights: [Highlight] { viewModel.allHighlights}
    
    var body: some View {
        NavigationStack{
            VStack{
                headerView
                favortiesView
                dividerView
                bookmarkedHighlights
                Spacer()
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
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)
            }
        }
    }
    
    private var favortiesView: some View {
        VStack{
            HStack {
                Text("Favorite Sports")
                    .font(Constants.Fonts.Header.h2)
                    .foregroundStyle(Constants.Colors.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button{
                   //do nothing for now
                } label: {
                    HStack {
                        Text("Edit")
                            .font(Constants.Fonts.Body.medium)
                            .foregroundStyle(Constants.Colors.crimson)
                        Image("Arrowhead")
                            .resizable()
                            .frame(width: 8.23, height: 15.48)
                    }
                }
            }
            .padding(.vertical, 10)
            ScrollViewReader{ proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(Sport.allCases) { sport in //will use the articles as filler
                            makeSPortIcon(sport: sport)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    private func makeSPortIcon(sport: Sport) -> some View {
        VStack(spacing: 8) {
            Image(sport.description + "-g")
                .resizable()
                .scaledToFit()
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
                Image("tabler_gender-female")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 10, height: 10)
                    .frame(width: 18, height: 18)
                    .background(Circle().fill(Constants.Colors.gray_border))

                Text("W")
                    .font(Constants.Fonts.Label.normal)
                    .foregroundStyle(Constants.Colors.gray_text)
            }
        }
        .frame(width: 96)
    }
    
    private var bookmarkedHighlights: some View {
        VStack {
            HStack {
                Text("Bookmarked Highlights")
                    .font(Constants.Fonts.Header.h2)
                    .foregroundStyle(Constants.Colors.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    Text("Show all")
                        .font(Constants.Fonts.Body.normal)
                        .foregroundStyle(Constants.Colors.gray_liner)
                    Image("ArrowheadGray")
                        .resizable()
                        .frame(width: 8.23, height: 15.48)
                }
            }
            .padding(.horizontal, 20)

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
                    // empty for now
                } label: {
                    Text("Log In")
                        .font(Constants.Fonts.Label.medium)
                        .foregroundStyle(Color.white)
                        .frame(width: 295, height: 34)
                        .background(Capsule().fill(Constants.Colors.crimson))
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 20)
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
    }
}



// MARK: - Preview

#Preview {
    NonSignedInProfileView()
        .environmentObject(HighlightsViewModel.shared) //need to change vm
}
