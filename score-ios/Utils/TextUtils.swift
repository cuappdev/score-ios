//
//  TextUtils.swift
//  score-ios
//
//  Created by Jay Zheng on 3/12/25.
//

import SwiftUI

struct TextUtil {
    static func trailingFadeWhite(width: CGFloat = 30) -> some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.clear, Color.white]),
            startPoint: .leading,
            endPoint: .trailing
        )
        .frame(width: width)
        .allowsHitTesting(false)
    }
}

extension String {
    /// remove "University of " and replay it with "U", eg. University of Miama -> UMiami
    func removingUniversityPrefix() -> String {
        return self.localizedCaseInsensitiveContains("University of ")
        ? self.replacingOccurrences(of: "University of ", with: "U ", options: .caseInsensitive)
        : self
    }
}
