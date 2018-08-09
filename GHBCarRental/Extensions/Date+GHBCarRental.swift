//
//  Date+GHBCarRental.swift
//  GHBCarRental
//
//  Created by George Brickley on 8/6/18.
//  Copyright © 2018 George Brickley. All rights reserved.
//

import Foundation

extension Date {
    
    /// Whether or not two dates have the same month and year
    func isSameMonthAndYearAsDate(_ date: Date) -> Bool
    {
        return isInSameMonth(date: date) && isInSameYear(date: date)
    }
    
    /// Whether or not two dates have the same month
    func isInSameMonth(date: Date) -> Bool
    {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .month)
    }
    
    /// Whether or not two dates have the same year
    func isInSameYear(date: Date) -> Bool
    {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .year)
    }
    
    /// The date, as a date string in the form 'Jan 10th after 5pm'
    func briefDateStringWithDateTimeSepatingString(_ string: String) -> String
    {
        let calendar = Calendar.current
        let anchorComponents = calendar.dateComponents([.day, .month, .year], from: self)
        let day = anchorComponents.day
        let ordinalSuffix = ordinalSuffixForDayNumber(day)
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "MMM d'\(ordinalSuffix) \(string) 'h:mm a"
        return formatter.string(from: self)
    }
    
    /// Returns a date with all components that same except the time updated
    func dateWithUpdatedTime(hour: Int, min: Int) -> Date
    {
        let x: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let cal = Calendar.current
        var components = cal.dateComponents(x, from: self)
        
        components.timeZone = TimeZone.current
        components.hour = hour
        components.minute = min
        components.second = 0
        
        return cal.date(from: components)!
    }
    
    /// The appropriate ordinal suffix for a given day of the month ('st','nd','rd','th')
    func ordinalSuffixForDayNumber(_ dayNumber: Int?) -> String
    {
        switch (dayNumber) {
        case 1, 21, 31:
            return "st"
        case 2, 22:
            return "nd"
        case 3, 23:
            return "rd"
        default:
            return "th"
        }
    }
}
