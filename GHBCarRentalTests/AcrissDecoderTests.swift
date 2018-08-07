//
//  AcrissDecoderTests.swift
//  GHBCarRentalTests
//
//  Created by George Brickley on 8/6/18.
//  Copyright © 2018 George Brickley. All rights reserved.
//

import XCTest
@testable import GHBCarRental

class AcrissDecoderTests: XCTestCase {
    
    var decoder: AcrissDecoder!
        
    override func setUp() {
        super.setUp()
        decoder = AcrissDecoder()
    }
    
    override func tearDown() {
        decoder = nil
        super.tearDown()
    }
    
    func testAcrissDecoderForVehicleTypeMini()
    {
        // If:
        let firstLetters = ["M","N"]
        
        // Then:
        let expectedCategory = VehicleCategory.mini
        let isCorrect = codesStartingWithFirstLetters(firstLetters, decodeToCategory: expectedCategory)
        XCTAssert(isCorrect, "Mini acriss code not properly decoded")
    }
    
    func testAcrissDecoderForVehicleTypeEconomy()
    {
        // If:
        let firstLetters = ["E","H"]
        
        // Then:
        let expectedCategory = VehicleCategory.economy
        let isCorrect = codesStartingWithFirstLetters(firstLetters, decodeToCategory: expectedCategory)
        XCTAssert(isCorrect, "Economy acriss code not properly decoded")
    }
    
    func testAcrissDecoderForVehicleTypeCompact()
    {
        // If:
        let firstLetters = ["C","D"]
        
        // Then:
        let expectedCategory = VehicleCategory.compact
        let isCorrect = codesStartingWithFirstLetters(firstLetters, decodeToCategory: expectedCategory)
        XCTAssert(isCorrect, "Compact acriss code not properly decoded")
    }
    
    func testAcrissDecoderForVehicleTypeStandard()
    {
        // If:
        let firstLetters = ["I","J","S","R"]
        
        // Then:
        let expectedCategory = VehicleCategory.standard
        let isCorrect = codesStartingWithFirstLetters(firstLetters, decodeToCategory: expectedCategory)
        XCTAssert(isCorrect, "Standard acriss code not properly decoded")
    }
    
    func testAcrissDecoderForVehicleTypeFullsize()
    {
        // If:
        let firstLetters = ["F","G"]
        
        // Then:
        let expectedCategory = VehicleCategory.fullsize
        let isCorrect = codesStartingWithFirstLetters(firstLetters, decodeToCategory: expectedCategory)
        XCTAssert(isCorrect, "Fullsize acriss code not properly decoded")
    }
    
    func testAcrissDecoderForVehicleTypePremium()
    {
        // If:
        let firstLetters = ["P","U"]
        
        // Then:
        let expectedCategory = VehicleCategory.premium
        let isCorrect = codesStartingWithFirstLetters(firstLetters, decodeToCategory: expectedCategory)
        XCTAssert(isCorrect, "Premium acriss code not properly decoded")
    }
    
    func testAcrissDecoderForVehicleTypeLuxury()
    {
        // If:
        let firstLetters = ["L","W"]
        
        // Then:
        let expectedCategory = VehicleCategory.luxury
        let isCorrect = codesStartingWithFirstLetters(firstLetters, decodeToCategory: expectedCategory)
        XCTAssert(isCorrect, "Luxury acriss code not properly decoded")
    }
    
    func testAcrissDecoderForVehicleTypeOversized()
    {
        // If:
        let firstLetters = ["O"]
        
        // Then:
        let expectedCategory = VehicleCategory.oversize
        let isCorrect = codesStartingWithFirstLetters(firstLetters, decodeToCategory: expectedCategory)
        XCTAssert(isCorrect, "Oversized acriss code not properly decoded")
    }
    
    func testAcrissDecoderForVehicleTypeUnknown()
    {
        // If:
        let firstLetters = [" ","Z","1",""]
        
        // Then:
        let expectedCategory = VehicleCategory.unknown
        let isCorrect = codesStartingWithFirstLetters(firstLetters, decodeToCategory: expectedCategory)
        XCTAssert(isCorrect, "Unknown acriss code not properly decoded")
    }

    func codesStartingWithFirstLetters(_ firstLetters: Array<String>, decodeToCategory expectedCategory: VehicleCategory) -> Bool
    {
        for firstLetter in firstLetters {
            let acrissCode = "\(firstLetter)ZZZ"
            let calculatedCategory = decoder.vehicleCategoryFor(acrissCode: acrissCode)
            if (calculatedCategory != expectedCategory) {
                return false
            }
        }
        return true
    }
}
