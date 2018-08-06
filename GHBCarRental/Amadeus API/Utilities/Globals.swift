//
//  Globals.swift
//  GHBCarRental
//
//  Created by George Brickley on 8/5/18.
//  Copyright © 2018 George Brickley. All rights reserved.
//

import Foundation

// Enum generic used to pass data back from API requests
enum Result<T> {
    case success(T)
    case error(code: Int, description: String, moreInfo: String)
}

struct AmadeusAPIConstant {
    static let baseUrl = "https://api.sandbox.amadeus.com/v1.2"
    static let apiKey = "UJQDEOHNl22Xwr3yiXD5tXiGo56QGnzi" // TODO: Including API key here for now, since it is only a sandbox key
}

struct AmadeusAPIDefaults {
    static let language = "EN"
    static let currencyType = "USD"
}
