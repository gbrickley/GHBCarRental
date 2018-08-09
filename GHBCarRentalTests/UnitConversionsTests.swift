//
//  UnitConverterTests.swift
//  GHBCarRentalTests
//
//  Created by George Brickley on 8/5/18.
//  Copyright © 2018 George Brickley. All rights reserved.
//

import XCTest
@testable import GHBCarRental

class UnitConversionsTests: XCTestCase {
    
    var unitConverter: UnitConversions!
    
    override func setUp() {
        super.setUp()
        unitConverter = UnitConversions()
    }
    
    override func tearDown() {
        unitConverter = nil
        super.tearDown()
    }
    
    func testMilesToKilometerConversion()
    {
        // If:
        let miles = 100
        
        // When:
        let calculatedKm = unitConverter.kilometersFrom(miles: miles)
        
        // Then:
        let expectedKm: Double = 160.934
        XCTAssertEqual(calculatedKm, expectedKm, accuracy: 0.001)
    }
    
    func testMetersToMilesConversion()
    {
        // If:
        let meters = 100.00
        
        // When:
        let calculatedMiles = unitConverter.milesFrom(meters: meters)
        
        // Then:
        let expectedMiles: Double = 0.0621371
        XCTAssertEqual(calculatedMiles, expectedMiles, accuracy: 0.001)
    }
}
