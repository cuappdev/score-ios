//
//  EmptyProfileView.swift
//  score-ios
//
//  Created by Zara Khan on 10/21/26.
//

import SwiftUI

struct EmptyProfileView: View {
    @EnvironmentObject var viewModel: HighlightsViewModel //will implement later
    
    var body: some View {
        NavigationStack {
            VStack {
                headerViewEmpty
                dividerView
                favortiesViewEmpty
                dividerView
                bookmarkedHighlightsEmpty
                Spacer()
            }
        }
    }
    
    var dividerView: some View {
        Divider()
            .background(Constants.Colors.gray_liner)
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
    }
    
    var headerViewEmpty: some View {
        Group {
            VStack {
                HStack {
                    Text("Profile")
                        .font(Constants.Fonts.Header.h1)
                        .font(Constants.Fonts.semibold24)
                        .foregroundStyle(Constants.Colors.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Button {
                        // do nothing rn
                    } label: {
                        Image("Notifications")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    Button {
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
            HStack {
                Image("Blank Profile")
                    .resizable()
                    .frame(width: 70, height: 70)
                VStack {
                    Text("Zara Khan")
                        .font(Constants.Fonts.Header.h2)
                        .foregroundStyle(Constants.Colors.gray_text)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Button {
                        // do nothing rn
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
    }
    
    var favortiesViewEmpty: some View {
        VStack {
            HStack {
                Text("Favorite Sports")
                    .font(Constants.Fonts.Header.h2)
                    .foregroundStyle(Constants.Colors.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack(spacing: 2) {
                    Text("Edit")
                        .font(Constants.Fonts.Label.normal)
                        .foregroundStyle(Constants.Colors.gray_liner)
                    Image("ArrowheadGray")
                        .resizable()
                        .frame(width: 15, height: 15)
                }
            }
            .padding(.bottom, 20)
            
            Button {
                // do nothing rn
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
        }
        .padding(.horizontal, 20)
    }
    
    var bookmarkedHighlightsEmpty: some View {
        VStack {
            HStack {
                Text("Bookmarked Highlights")
                    .font(Constants.Fonts.Header.h2)
                    .foregroundStyle(Constants.Colors.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    Text("Show all")
                        .font(Constants.Fonts.Label.normal)
                        .foregroundStyle(Constants.Colors.gray_liner)
                    Image("ArrowheadGray")
                        .resizable()
                        .frame(width: 8.23, height: 15.48)
                }
            }
            .padding(.horizontal, 20)

            VStack(spacing: 12) {
                Image(systemName: "bookmark.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(Color(white: 0.75))           // darker bookmark
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(Color(white: 0.91))) // light gray circle
                Text("No bookmarks yet")
                    .font(Constants.Fonts.Body.normal)
                    .foregroundStyle(Constants.Colors.black)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 175)
            .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1.5)
            )
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
    }
}

// MARK: - Preview

#Preview {
    EmptyProfileView()
        .environmentObject(HighlightsViewModel.shared) //need to change vm
}
