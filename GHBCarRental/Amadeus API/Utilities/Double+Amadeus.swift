//
//  Float+GHBCarRental.swift
//  GHBCarRental
//
//  Created by George Brickley on 8/6/18.
//  Copyright © 2018 George Brickley. All rights reserved.
//

import Foundation

extension Double {
    
    /// The double rounded to the specified number of decimal places
    func roundToPrecision(_ digitsAfterDecimal: Int) -> Double
    {
        let divisor = pow(10.0, Double(digitsAfterDecimal))
        return (self * divisor).rounded() / divisor
    }
    
    /// The double as a localized currency string
    func asLocalizedCurrencyStringWith(currencyCode: String) -> String
    {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        return formatter.string(from: self as NSNumber) ?? ""
    }
}
