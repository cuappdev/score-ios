//
//  String+Extension.swift
//  score-ios
//
//  Created by Jay Zheng on 3/20/25.
//

import SwiftUI

extension String {
    /// remove "University of " and replay it with "U", eg. University of Miama -> UMiami
    func removingUniversityPrefix() -> String {
        return self.localizedCaseInsensitiveContains("University of ")
        ? self.replacingOccurrences(of: "University of ", with: "U ", options: .caseInsensitive)
        : self
    }
}
