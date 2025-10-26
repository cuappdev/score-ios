//
//  TabViewIcon.swift
//  score-ios
//
//  Created by Hsia Lu wu on 11/16/24.
//

import SwiftUI

enum MainTab: String, CaseIterable, Identifiable {
    case schedule = "Schedule"
    case highlights = "Highlights"
    case scores = "Scores"
    
    var id: Self { self }
    
    var imageName: String {
        switch self {
        case .schedule: return "schedule"
        case .highlights: return "highlight"
        case .scores: return "scoreboard"
        }
    }
}

struct TabViewIcon: View {
    @Binding var selectedTab: MainTab
    let tab: MainTab
    
    var body: some View {
        Button {
            selectedTab = tab
        } label: {
            VStack {
                Image(selectedTab == tab ? "\(tab.imageName)-selected" : tab.imageName)
                    .resizable()
                    .frame(width: 28, height: 28)
                    .tint(Constants.Colors.gray_icons)
                
                Text(tab.rawValue)
                    .font(Constants.Fonts.buttonLabel)
                    .foregroundStyle(selectedTab == tab ? Constants.Colors.primary_red : Constants.Colors.unselectedText)
            }
        }
    }
}

#Preview {
    TabViewIcon(selectedTab: .constant(.schedule), tab: .schedule)
}
