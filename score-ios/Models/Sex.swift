//
//  Sex.swift
//  score-ios
//
//  Created by Daniel Chuang on 2/23/25.
//

import SwiftUI

enum Sex : Identifiable, CaseIterable, CustomStringConvertible {
    var id: Self { self }
    
    case Both
    case Men
    case Women
    
    var description: String {
        switch self {
        case .Both:
            return "All"
        case .Men:
            return "Men's"
        case .Women:
            return "Women's"
        }
    }
    
    var filterDescription: String {
        switch self {
        case .Both:
            return "All"
        case .Men:
            return "Mens"
        case .Women:
            return "Womens"
        }
    }
    // This is strictly for filtering purposes, all datum should have one of Men or Women
    static func index(of sex: Sex) -> Int? {
        return allCases.firstIndex(of: sex)
    }
}
