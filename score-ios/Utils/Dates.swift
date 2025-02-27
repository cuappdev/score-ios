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
    
    static let fullDateFormatter = ISO8601DateFormatter() // eg 2016-04-14T10:44:00+0000
    
    static func dateToStringFull(date: Date) -> String {
        return fullDateFormatter.string(from: date)
    }
    
    static func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d/yyyy"
        return dateFormatter.string(from: date)
    }
    
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
 
    static func parseDate(dateString: String, timeString: String) -> Date {
        // parse the date without year
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d (EEE)" // Matches "Feb 23 (Fri)"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Ensures consistent parsing
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC") // Adjust timezone if necessary
        let parsedDate = dateFormatter.date(from: dateString) ?? Date()
        
        // parse the time
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a" // Matches "4:00 p.m."
        timeFormatter.locale = Locale(identifier: "en_US_POSIX")
        timeFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let parsedTime = timeFormatter.date(from: timeString) ?? Date()
        
        // get the current year
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        
        // set the year of the parsed date to the current year
        // Set the year of the parsed date to the current year
        var dateComponents = calendar.dateComponents([.month, .day], from: parsedDate)
        dateComponents.year = currentYear
        let timeComponents = calendar.dateComponents([.hour, .minute], from: parsedTime)
        dateComponents.hour = timeComponents.hour
        dateComponents.minute = timeComponents.minute

        // returns the date with the year set to the current year, callback to current date if parsing fails
        return calendar.date(from: dateComponents) ?? Date()
    }
}
