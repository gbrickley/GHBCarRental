//
//  DateFormatterTests.swift
//  GHBCarRentalTests
//
//  Created by George Brickley on 8/5/18.
//  Copyright © 2018 George Brickley. All rights reserved.
//

import XCTest
@testable import GHBCarRental

class DateFormatterTests: XCTestCase {
    
    var date: Date!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        date = nil
        super.tearDown()
    }
    
    func testAmadeusAPIDateStringFormat()
    {
        // If:
        date = Date(timeIntervalSince1970: 1533523802)
        
        // When:
        let calculatedString = date.amadeusAPIFormattedDateTimeString()
        
        // Then:

        let expectedString = "2018-08-06T02:50:02"
        XCTAssertEqual(calculatedString, expectedString, "Date not properly converted to Amadeus API date string format")
    }

}
