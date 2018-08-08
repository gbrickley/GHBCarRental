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

struct Strings {
    // The message we'll display to the user before we actually ask for permission to their location
    static let locationPreAuthorizationMessage = "GHBCarRental would like to access you location so that we can tailor your searches to your current location."
}
