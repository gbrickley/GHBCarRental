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
        let testDate = Date(timeIntervalSince1970: 1533523802)
        
        // When:
        let calculatedString = testDate.amadeusAPIFormattedDateTimeString()
        
        // Then:
        let pattern = "(\\d{4})-(\\d{2})-(\\d{2})T(\\d{2})\\:(\\d{2})\\:(\\d{2})"
        let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)

        let matches = regex.matches(in: calculatedString, options: [], range: NSRange(location: 0, length: calculatedString.count))

        let isValid = matches.count == 1 && matches[0].range.location == 0 && matches[0].range.length == calculatedString.count
        XCTAssert(isValid, "Date not properly formatted")
    }
}
