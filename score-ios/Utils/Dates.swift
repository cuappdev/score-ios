//
//  Dates.swift
//  score-ios
//
//  Created by Daniel Chuang on 9/11/24.
//

// TODO: FIX


import SwiftUI


extension Date {
    
    static let currentDate = Date()
    
    static let dateFormatter = ISO8601DateFormatter() // eg 2016-04-14T10:44:00+0000
    
    static func dateToString(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    // TODO: FIX
//    static func stringToDate(string: String) throws -> Date {
//        if let date = dateFormatter.date(from: string) {
//            return date
//        } else {
//            throw ScoreError.invalidInput("Invalid date format")
//        }
//    }
    
    static func dateComponents(year: Int, month: Int, day: Int, hour: Int, minute: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        
        let calendar = Calendar.current
        return calendar.date(from: components) ?? Date()
    }
    
}
