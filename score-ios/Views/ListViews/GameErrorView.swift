//
//  GameErrorView.swift
//  score-ios
//
//  Created by Jayson Hahn on 3/22/25.
//

import Foundation
import SwiftUI

struct GameErrorView: View {

    @ObservedObject var viewModel: GamesViewModel

    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()

                Image(systemName: "exclamationmark.bubble")
                    .resizable()
                    .frame(width: 64, height: 64)
                    .padding(.bottom, 16)

                Text("Oops! Schedules failed to load.")
                    .font(Constants.Fonts.Header.h2)
                    .padding(.bottom, 8)

                Text("Please try again later.")
                    .font(Constants.Fonts.Body.normal)

                Spacer()

                Button {
                    viewModel.fetchGames()
                } label: {
                    HStack {
                        Image(systemName: "arrow.trianglehead.2.clockwise")
                        Text("Try again")
                            .font(Constants.Fonts.Body.medium)
                    }
                    .padding(.all, 10)
                }
                .background(Constants.Colors.crimson)
                .foregroundColor(Constants.Colors.white)
                .clipShape(Capsule())

                Spacer()
            }
        }
    }

}
