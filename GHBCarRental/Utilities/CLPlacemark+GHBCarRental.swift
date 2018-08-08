//
//  CLPlacemark+GHBCarRental.swift
//  GHBCarRental
//
//  Created by George Brickley on 8/6/18.
//  Copyright © 2018 George Brickley. All rights reserved.
//

import Foundation
import CoreLocation

extension CLPlacemark {
    
    /// Adds a border to the view
    func briefDescription() -> String
    {
        if let streetNum = self.subThoroughfare, let street = self.thoroughfare, let city = self.locality {
            return "\(streetNum) \(street) \(city)"
        } else if let name = self.name {
            return name
        } else {
            return ""
        }
    }
}
