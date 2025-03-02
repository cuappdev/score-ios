//
//  UtilFunctions.swift
//  score-ios
//
//  Created by Jidong Zheng on 3/1/25.
//

import Foundation

class UtilFunctions {
    static func removeUniversityPrefix(from str: String) -> String {
        return str.localizedCaseInsensitiveContains("University of ") ? str.replacingOccurrences(of: "University of ", with: "U", options: .caseInsensitive) : str
    }
}

extension 
