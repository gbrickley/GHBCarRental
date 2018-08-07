//
//  UserLocationManager.swift
//  GHBCarRental
//
//  Created by George Brickley on 8/6/18.
//  Copyright © 2018 George Brickley. All rights reserved.
//

import Foundation
import CoreLocation

class UserLocationManager {
    
    // Singleton instance
    static let sharedInstance = UserLocationManager()
    
    /**
     The users current location.
     - returns: CLLocation
     */
    public func usersCurrentLocation() -> CLLocation?
    {
        return nil
    }
    
    /**
     The users current placemark location.
     - returns: CLPlacemark
     */
    public func usersCurrentPlacemark() -> CLPlacemark?
    {
        return nil
    }
}
