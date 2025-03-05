//
//  GameSectionHeaderView.swift
//  score-ios
//
//  Created by Daniel Chuang on 2/24/25.
//

import SwiftUI

struct GameSectionHeaderView: View {
    @StateObject private var vm = GamesViewModel.shared
    var headerTitle: String
    
    var body: some View {
        VStack {
            VStack {
                Text(headerTitle)
                    .font(Constants.Fonts.semibold24)
                    .frame(maxWidth: .infinity, alignment: .leading) // Align to the left
                PickerView(selectedSex: $vm.selectedSex, selectedIndex: $vm.selectedSexIndex)
                    .padding(.bottom, 12)
                    .frame(maxWidth: .infinity, alignment: .center)
                SportSelectorView()
            }
            .padding(.bottom, 16)
            
            Divider()
                .background(.clear)
        }
    }
}
