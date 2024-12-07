//
//  OrdinalSuffix.swift
//  score-ios
//
//  Created by Daniel Chuang on 12/4/24.
//

import Foundation

func ordinalSuffix(for number: Int) -> String {
    let lastDigit = number % 10
    let lastTwoDigits = number % 100
    
    if lastTwoDigits >= 11 && lastTwoDigits <= 13 {
        return "th"
    }
    
    switch lastDigit {
    case 1: return "st"
    case 2: return "nd"
    case 3: return "rd"
    default: return "th"
    }
}

func ordinalNumberString(for number: Int) -> String {
    return "\(number)\(ordinalSuffix(for: number))"
}
