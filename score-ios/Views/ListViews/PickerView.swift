//
//  PickerView.swift
//  score-ios
//
//  Created by Daniel Chuang on 9/14/24.
//

import SwiftUI

struct PickerView: View {

    @Binding var selectedSex: Sex
    @Binding var selectedIndex: Int

    // Constants for visual style - can be adjusted as needed
    private let capsulePadding: CGFloat = 6
    private let borderWidth: CGFloat = 2
    private let highlightHeight: CGFloat = 37

    var body: some View {
        GeometryReader { geometry in
            let totalWidth = geometry.size.width
            let totalHeight = geometry.size.height
            let segmentWidth = (totalWidth - (capsulePadding * 2)) / CGFloat(Sex.allCases.count)

            ZStack {
                // Background capsule
                Capsule()
                    .fill(Color.clear) // Clear background

                // Selected capsule indicator - smaller height
                Capsule()
                    .fill(Constants.Colors.selected)
                    .frame(width: segmentWidth, height: highlightHeight)
                    .offset(x: CGFloat(selectedIndex) * segmentWidth - (totalWidth - capsulePadding * 2) / 2 + segmentWidth / 2)
                    .animation(.spring(), value: selectedIndex)

                // Option buttons
                HStack(spacing: 0) {
                    ForEach(Array(Sex.allCases.enumerated()), id: \.1) { index, sex in
                        Button(action: {
                            withAnimation(.spring()) {
                                selectedSex = sex
                                selectedIndex = index
                            }
                        }) {
                            Text(sex.description)
                                .font(Constants.Fonts.gameTitle)
                                .foregroundStyle(selectedIndex == index ? Constants.Colors.selectedText : Constants.Colors.unselectedText)
                                .frame(width: segmentWidth, height: totalHeight - capsulePadding * 2)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(capsulePadding)

                // Border overlay
                Capsule()
                    .stroke(Constants.Colors.gray_liner, lineWidth: borderWidth)
                    .frame(width: totalWidth, height: totalHeight)
            }
        }
        .frame(height: 49)
    }

}

#Preview {
    PickerView(selectedSex: .constant(Sex.Both), selectedIndex: .constant(0))
}
