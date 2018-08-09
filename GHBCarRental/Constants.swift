//
//  Constants.swift
//  GHBCarRental
//
//  Created by George Brickley on 8/5/18.
//  Copyright © 2018 George Brickley. All rights reserved.
//

import Foundation

/// The default rental car search parameters
struct DefaultSearchParameters {
    // The default seach radius
    static let radius = 30
}

/// The default date and time properties
struct DefaultDates {
    
    // The default hour and minutes that we'll set for all pickups
    static let defaultPickupTimeHours = 9
    static let defaultPickupTimeMinutes = 0
    
    // The default hour and minutes that we'll set for all dropoffs
    static let defaultDropoffTimeHours = 17
    static let defaultDropoffTimeMinutes = 0
}

struct Strings {
    // The message we'll display to the user before we actually ask for permission to use their location
    static let locationPreAuthorizationMessage = "GHBCarRental would like to access you location so that we can tailor your searches to your current location."
}
