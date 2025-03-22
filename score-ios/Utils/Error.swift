//
//  Error.swift
//  score-ios
//
//  Created by Daniel Chuang on 9/14/24.
//

// TODO: FIX or DELETE


import SwiftUI

enum ScoreError: Error, Equatable {
    case invalidInput(String)
    case networkError
    case emptyData
    case unknownError

    static func == (lhs: ScoreError, rhs: ScoreError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidInput(let lhsMessage), .invalidInput(let rhsMessage)):
            return lhsMessage == rhsMessage
        case (.networkError, .networkError):
            return true
        case (.emptyData, .emptyData):
            return true
        case (.unknownError, .unknownError):
            return true
        default:
            return false
        }
    }
    
}
