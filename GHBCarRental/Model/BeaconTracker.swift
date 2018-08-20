//
//  BeaconTracker.swift
//  GHBCarRental
//
//  Created by George Brickley on 8/10/18.
//  Copyright © 2018 George Brickley. All rights reserved.
//

import Foundation
import CoreLocation

class BeaconTracker: NSObject {
    
    // Always access the beacon tracker through the shared instance
    static let sharedInstance = BeaconTracker()
    
    // To make sure the manager is always accessed through the `sharedInstance`
    private override init() {}
    
    /// Block used to return data about the user current location
    typealias BeaconHandler = (_ currentLocation: CLPlacemark?, _ error: String?) -> Void
    



}
