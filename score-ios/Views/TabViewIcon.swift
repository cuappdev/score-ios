//
//  TabViewIcon.swift
//  score-ios
//
//  Created by Hsia Lu wu on 11/16/24.
//

import SwiftUI

struct TabViewIcon: View {
    // MARK: - Properties

       @Binding var selectionIndex: Int

       let itemIndex: Int
       private let tabItems = ["schedule", "scoreboard"]
    
    var body: some View {
        Button {
                selectionIndex = itemIndex
                } label: {
                    VStack {
                        Image(itemIndex == selectionIndex ? "\(tabItems[itemIndex])-selected" : tabItems[itemIndex])
                            .resizable()
                            .frame(width: 28, height: 28)
                            .tint(Constants.Colors.gray_icons)
                        Text(itemIndex == 0 ? "Schedule" : "Scores")
                            .font(Constants.Fonts.buttonLabel)
                            .foregroundStyle(itemIndex == selectionIndex ? Constants.Colors.primary_red : Constants.Colors.unselectedText)
                    }
                }
    }
}

#Preview {
    TabViewIcon(selectionIndex: .constant(0), itemIndex: 0)
}
