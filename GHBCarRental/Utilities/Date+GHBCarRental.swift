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
}
