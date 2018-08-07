//
//  TimeInterval+GHBCarRental.swift
//  GHBCarRental
//
//  Created by George Brickley on 8/6/18.
//  Copyright © 2018 George Brickley. All rights reserved.
//

import Foundation

extension DateInterval {
    
    /// A string representing the interval in the form (Aug 4-12)
    func asShortStyleMonthAndDayString() -> String
    {
        let df = DateFormatter()
        df.dateFormat = DateFormatter.dateFormat(fromTemplate: "MMM d", options: 0, locale: nil)
        let fromStr = df.string(from: self.start)
        
        // If the date is the same month and year as the start date, don't show the month again
        if (self.start.isSameMonthAndYearAsDate(self.end)) {
            df.dateFormat = DateFormatter.dateFormat(fromTemplate: "d", options: 0, locale: nil)
        }
        
        let toStr = df.string(from: self.end)
        return "\(fromStr) – \(toStr)"
    }
}


