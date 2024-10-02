//
//  Error.swift
//  score-ios
//
//  Created by Daniel Chuang on 9/14/24.
//

// TODO: FIX or DELETE


import SwiftUI

enum ScoreError: Error {
    case invalidInput(String)
    case networkError(Int)
    case unknownError
}
