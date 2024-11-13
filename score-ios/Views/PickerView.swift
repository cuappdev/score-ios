//
//  PickerView.swift
//  score-ios
//
//  Created by Daniel Chuang on 9/14/24.
//

import SwiftUI

/// Custom PickerView code heavily inspired from https://www.reddit.com/r/SwiftUI/comments/qonfey/how_do_i_get_a_picker_that_looks_like_this_very/

private var buttonWidth : CGFloat = 100
private var buttonHeight : CGFloat = 37

struct PickerView: View {
    @Binding var selectedSex: Sex
    @State var selectedIndex: Int = 0
    
    var body: some View {
        ZStack (alignment: .leading) {
            
            Capsule()
                .fill(Constants.Colors.selected)
                .frame(width: buttonWidth, height: buttonHeight)
                .offset(x: 6 + CGFloat(selectedIndex) * 99)
                .animation(.spring(), value: selectedSex)
            
            // Options
            HStack (spacing: 0) {
                ForEach(
                    Array(Sex.allCases.enumerated()),
                    id: \.1
                ) {
                    index, sex in
                    if selectedSex == sex {
                        PickerSegmentView(sex: sex, selected: true)
                    } else {
                        PickerSegmentView(sex: sex, selected: false)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    selectedSex = sex
                                    selectedIndex = index
                                }
                            }
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(6)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Constants.Colors.gray_liner, lineWidth: 2)
                    .frame(width: 345, height: 49)
            )
        }
    }
}

struct PickerSegmentView: View {
    var sex : Sex
    var selected : Bool
    
    var body: some View {
        Text(sex.description)
            .font(Constants.Fonts.gameTitle)
            .foregroundStyle(selected ? Constants.Colors.selectedText : Constants.Colors.unselectedText)
            .frame(width: buttonWidth, height: buttonHeight)
    }
}

//#Preview {
//    PickerView(selectedSex: Sex.Both)
//}
