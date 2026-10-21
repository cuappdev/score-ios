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
        NavigationStack{
            VStack{
                headerViewEmpty
                dividerView
                favortiesViewEmpty
                dividerView
                bookmarkedHighlightsEmpty
            }
        }
    }
    
    
    var dividerView: some View {
        Divider()
               .background(Constants.Colors.gray_liner)
               .frame(width: 345, height: 0)
    }
    
    var headerViewEmpty: some View {
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
                Image("Blank Profile")
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
    
    var favortiesViewEmpty: some View {
        VStack{
            HStack{
                Text("Favorite Sports")
                    .font(Constants.Fonts.Header.h2)
                    .foregroundStyle(Constants.Colors.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                Text("Edit")
                    .font(Constants.Fonts.Label.normal)
                    .foregroundStyle(Constants.Colors.gray_liner)
                    .padding(.top, 24)
                Image("ArrowheadGray")
                    .resizable()
                    .frame(width: 8.23, height: 15.48)
                    .padding(.top, 24)
            }
            Button{
                // do nothing rn
            } label: {
                VStack{
                    Image("add")
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
                    Text("Add Sports")
                        .font(Constants.Fonts.Body.medium)
                        .foregroundStyle(Constants.Colors.black)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
            }
        }
    }
    
    var bookmarkedHighlightsEmpty: some View {
        VStack{
            HStack{
                Text("Bookmarked Highlights")
                    .font(Constants.Fonts.Header.h2)
                    .foregroundStyle(Constants.Colors.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                Text("Show all")
                    .font(Constants.Fonts.Label.normal)
                    .foregroundStyle(Constants.Colors.gray_border)
                    .padding(.top, 24)
                Image("ArrowheadGray")
                    .resizable()
                    .frame(width: 8.23, height: 15.48)
                    .padding(.top, 24)
            }
        }
    }
}


// MARK: - Preview

#Preview {
    EmptyProfileView()
        .environmentObject(HighlightsViewModel.shared) //need to change vm
}
