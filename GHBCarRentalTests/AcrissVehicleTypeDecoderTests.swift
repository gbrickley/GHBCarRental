//
//  AcrissVehicleTypeDecoderTests.swift
//  GHBCarRentalTests
//
//  Created by George Brickley on 8/7/18.
//  Copyright © 2018 George Brickley. All rights reserved.
//

import XCTest
@testable import GHBCarRental

class AcrissVehicleTypeDecoderTests: XCTestCase {
    
    var decoder: AcrissDecoder!
    
    override func setUp() {
        super.setUp()
        decoder = AcrissDecoder()
    }
    
    override func tearDown() {
        decoder = nil
        super.tearDown()
    }
    
    func testAcrissDecoderForVehicleTypeTwoThreeDoor()
    {
        // If:
        let secondLetters = ["B"]
        
        // Then:
        let expectedType = "2-3 Door"
        let isCorrect = codesWithSecondLetters(secondLetters, decodeToCategory: expectedType)
        XCTAssert(isCorrect, "2-3 doors code not properly decoded")
    }
    
    func testAcrissDecoderForVehicleTypeInvalid()
    {
        // If:
        let secondLetters = ["", "A", "ZZ", "1"]
        
        // Then:
        let isCorrect = codesWithSecondLetters(secondLetters, decodeToCategory: nil)
        XCTAssert(isCorrect, "Invlaid vehicle type code not properly decoded")
    }
 
    func codesWithSecondLetters(_ secondLetters: Array<String>, decodeToCategory expectedType: String?) -> Bool
    {
        for firstLetter in secondLetters {
            let acrissCode = "Z\(firstLetter)ZZ"
            let calculatedType = decoder.vehicleTypeDescriptionFor(acrissCode: acrissCode)
            if (calculatedType != expectedType) {
                return false
            }
        }
        return true
    }
}
