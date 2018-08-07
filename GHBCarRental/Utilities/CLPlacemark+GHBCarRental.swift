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
        print("[CLPlacemark]: Name: \(String(describing: self.name))")
        print("[CLPlacemark]: Sub: \(String(describing: self.subThoroughfare))")
        print("[CLPlacemark]: Street: \(String(describing: self.thoroughfare))")
        print("[CLPlacemark]: City: \(String(describing: self.locality))")
        print("[CLPlacemark]: State: \(String(describing: self.administrativeArea))")
        
        if let streetNum = self.subThoroughfare, let street = self.thoroughfare, let city = self.locality, let state = self.administrativeArea {
            return "\(streetNum) \(street) \(city), \(state)"
        } else if let name = self.name {
            return name
        } else {
            return ""
        }
    }
}
