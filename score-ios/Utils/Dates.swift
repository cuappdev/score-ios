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

    /// Formatter for "yyyy-MM-dd'T'HH:mm:ssXXXXX" strings
    static var highlightDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX" // ISO 8601 format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        return formatter
    }()
    
    /// Checks if a date is any time today.
    static func isToday(_ date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
    }

    // Return true if 'date' is within 'days' from today
    static func isWithinPastDays(_ date: Date, days: Int) -> Bool {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        
        guard let pastDate = calendar.date(byAdding: .day, value: -days, to: startOfToday) else {
            return false
        }
        
        return date >= pastDate && date < startOfToday
    }
    
    static func parseDate(dateString: String, timeString: String) -> Date {
        // Set up date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Ensures consistent parsing

        // Try to parse with year format first
        dateFormatter.dateFormat = "MMM d (EEE) yyyy" // Matches "Feb 23 (Fri) 2024"
        var parsedDate = dateFormatter.date(from: dateString)
        
        // If that fails, fall back to parsing without year and determine the appropriate year
        if parsedDate == nil {
            dateFormatter.dateFormat = "MMM d (EEE)" // Matches "Feb 23 (Fri)"
            parsedDate = dateFormatter.date(from: dateString)

            if let date = parsedDate {
                let calendar = Calendar.current
                let currentDate = Date()
                let currentYear = calendar.component(.year, from: currentDate)
                let currentMonth = calendar.component(.month, from: currentDate)
                let parsedMonth = calendar.component(.month, from: date)

                // Create new date components from the parsed date
                var dateComponents = calendar.dateComponents([.month, .day], from: date)
                dateComponents.year = currentYear

                // Update parsedDate with the correct year
                if let updatedDate = calendar.date(from: dateComponents) {
                    parsedDate = updatedDate
                }
            }
        }

        // Standardize the time string format
        var standardizedTimeString = timeString
        standardizedTimeString = standardizedTimeString.replacingOccurrences(of: "p.m.", with: "PM")
        standardizedTimeString = standardizedTimeString.replacingOccurrences(of: "a.m.", with: "AM")
        standardizedTimeString = standardizedTimeString.replacingOccurrences(of: "pm", with: "PM")
        standardizedTimeString = standardizedTimeString.replacingOccurrences(of: "am", with: "AM")

        // Cut off string after AM/PM
        if let range = standardizedTimeString.range(of: "AM") {
            standardizedTimeString = String(standardizedTimeString[..<range.upperBound])
        } else if let range = standardizedTimeString.range(of: "PM") {
            standardizedTimeString = String(standardizedTimeString[..<range.upperBound])
        }

        // Parse the time
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "en_US_POSIX")
        timeFormatter.dateFormat = "h:mm a" // Matches "4:00 PM"
        let parsedTime = timeFormatter.date(from: standardizedTimeString)

        // Set up calendar
        let calendar = Calendar.current

        // TODO: handle when it fails to parse both better
        // Extract components from the parsedDate
        var dateComponents = calendar.dateComponents([.month, .day, .year], from: parsedDate ?? Date())

        // Get time components from parsedTime
        let timeComponents = calendar.dateComponents([.hour, .minute], from: parsedTime ?? Date())

        // Add time components to date components
        dateComponents.hour = timeComponents.hour
        dateComponents.minute = timeComponents.minute

        return calendar.date(from: dateComponents) ?? Date()
    }
}
