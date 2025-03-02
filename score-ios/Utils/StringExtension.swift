//
//  UtilFunctions.swift
//  score-ios
//
//  Created by Jidong Zheng on 3/1/25.
//

import Foundation

extension String {
    /// remove "University of " and replay it with "U", eg. University of Miama -> UMiami
    func removingUniversityPrefix() -> String {
        return self.localizedCaseInsensitiveContains("University of ")
            ? self.replacingOccurrences(of: "University of ", with: "U", options: .caseInsensitive)
            : self
    }
}
