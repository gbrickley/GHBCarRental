//
//  UnitConverter.swift
//  GHBCarRental
//
//  Created by George Brickley on 8/5/18.
//  Copyright © 2018 George Brickley. All rights reserved.
//

import Foundation

class UnitConversions {
    
    // Converts from miles to kilometers
    func kilometersFrom(miles: Int) -> Double {
        return Double(miles) * 1.60934
    }
    
    // Converts from miles to kilometers
    func milesFrom(meters: Double) -> Double
    {
        return meters / 1609.34
    }
}


