//
//  Dates.swift
//  score-ios
//
//  Created by Daniel Chuang on 9/11/24.
//

import SwiftUI


extension Date {
    
    static let currentDate = Date()
    
    static let dateFormatter = ISO8601DateFormatter() // eg 2016-04-14T10:44:00+0000
    
    static func dateToString(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    static func stringToDate(string: String) -> Date {
        return dateFormatter.date(from: string)!
    }

}
