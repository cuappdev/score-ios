//
//  GameSectionHeaderView.swift
//  score-ios
//
//  Created by Daniel Chuang on 2/24/25.
//

import SwiftUI

struct GameSectionHeaderView: View {

    @StateObject private var vm = GamesViewModel.shared
    @ObservedObject private var auth = AuthManager.shared
    var headerTitle: String
    var sortsByNextGame = false

    var body: some View {
        VStack {
            VStack {
                Text(headerTitle)
                    .font(Constants.Fonts.semibold24)
                    .foregroundStyle(Constants.Colors.black)
                    .frame(maxWidth: .infinity, alignment: .leading) // Align to the left
                PickerView(selectedSex: $vm.selectedSex, selectedIndex: $vm.selectedSexIndex)
                    .padding(.bottom, 12)
                    .frame(maxWidth: .infinity, alignment: .center)
                if vm.selectedSex == .Both && auth.favoriteTeams.isEmpty {
                    NoFavoritesBanner()
                } else {
                    SportSelectorView(showsFavoritesOnly: true, sortsByNextGame: sortsByNextGame)
                }
            }
            .padding(.bottom, 16)

            Divider()
                .background(.clear)
        }
    }
}
