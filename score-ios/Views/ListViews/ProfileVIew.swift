//
//  ProfileVIew.swift
//  score-ios
//
//  Created by Zara Khan on 9/30/26.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: HighlightsViewModel //will implement later
    
    var body: some View {
        NavigationStack{
            VStack{
                headerView
                Divider()
                       .background(Constants.Colors.gray_liner)
                       .frame(width: 345, height: 0)
                favortiesView
            }
        }
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
                        Image("Vector")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    Button{
                        // do nothing rn
                    } label: {
                        Image("Settings")
                            .resizable()
                            .frame(width: 30, height: 30)
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
    
    var favortiesView: some View { //not done
        VStack{
            HStack{
                Text("Favorite Sports")
                    .font(Constants.Fonts.Header.h2)
                    .foregroundStyle(Constants.Colors.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
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
