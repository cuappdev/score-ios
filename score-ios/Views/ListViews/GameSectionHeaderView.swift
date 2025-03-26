//
//  GameSectionHeaderView.swift
//  score-ios
//
//  Created by Daniel Chuang on 2/24/25.
//

import SwiftUI

struct GameSectionHeaderView: View {

    @StateObject private var vm = GamesViewModel.shared
    @Binding var showingFiltersheet: Bool
    
    var headerTitle: String

    var body: some View {
        VStack {
            VStack {
                
                HStack {
                    Text(headerTitle)
                        .font(Constants.Fonts.semibold24)
                        .foregroundStyle(Constants.Colors.black)
                        .frame(maxWidth: .infinity, alignment: .leading) // Align to the left
                    
                    // if upcoming, show filter button
                    if (headerTitle == "Game Schedule") {
                        Button {
                            // show filter sheet
                            showingFiltersheet.toggle()
                        } label: {
                            Image(systemName: "line.horizontal.3.decrease.circle")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(Constants.Colors.gray_icons)
                        }
                    }
                }
                
                PickerView(selectedSex: $vm.selectedSex, selectedIndex: $vm.selectedSexIndex)
                    .padding(.bottom, 12)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                SportSelectorView()
            }
            .padding(.bottom, 16)

            Divider()
                .background(.clear)
                .padding(.bottom, 16)
        }
    }
}
