//
//  CollatzConjectureTests.swift
//  GHBCarRentalTests
//
//  Created by George Brickley on 8/10/18.
//  Copyright © 2018 George Brickley. All rights reserved.
//

import XCTest
@testable import GHBCarRental

class CollatzConjectureTests: XCTestCase {
    
    var conjecture: CollatzConjecture!
    
    override func setUp() {
        super.setUp()
        conjecture = CollatzConjecture()
    }
    
    override func tearDown() {
        conjecture = nil
        super.tearDown()
    }
    
    func testMaxStepsLessThanOneHundred() {
        
        // Given:
        let start = 1
        let finish = 100
        
        // When:
        let calculatedCount = conjecture.maxStepCountForSet(startingAt: start, endingBefore: finish)
        
        // Then:
        let expectedCount = 118
        XCTAssertEqual(calculatedCount, expectedCount, "Calculated steps: \(calculatedCount) does not equal expected steps: \(expectedCount)")
    }
    
    func testMaxStepsLessThanOneThousand() {
        
        // Given:
        let start = 1
        let finish = 1000
        
        // When:
        let calculatedCount = conjecture.maxStepCountForSet(startingAt: start, endingBefore: finish)
        
        // Then:
        let expectedCount = 178
        XCTAssertEqual(calculatedCount, expectedCount, "Calculated steps: \(calculatedCount) does not equal expected steps: \(expectedCount)")
    }
    
    func testMaxStepsLessThanOneMillion() {
        
        // Given:
        let start = 1
        let finish = 1000000
        
        // When:
        let calculatedCount = conjecture.maxStepCountForSet(startingAt: start, endingBefore: finish)
        
        // Then:
        let expectedCount = 524
        XCTAssertEqual(calculatedCount, expectedCount, "Calculated steps: \(calculatedCount) does not equal expected steps: \(expectedCount)")
    }
}
