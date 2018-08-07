//
//  RentalProviderTests.swift
//  GHBCarRentalTests
//
//  Created by George Brickley on 8/6/18.
//  Copyright © 2018 George Brickley. All rights reserved.
//

import XCTest
import CoreLocation
@testable import GHBCarRental
@testable import SwiftyJSON
@testable import SwiftyJSONModel

class RentalProviderTests: XCTestCase {
    
    var provider1: RentalProvider!
    var provider2: RentalProvider!
        
    override func setUp()
    {
        super.setUp()
        
        let json1: JSON = ["branch_id": "branch1",
                           "provider": ["company_name": "Company Name", "company_code": "CC"],
                           "location": ["latitude": 35.07057, "longitude": -114.58937],
                           "address": ["line1": "Line1", "line2": "Line2", "city": "City", "region": "ST", "country": "US"]]
        
        let json2: JSON = ["branch_id": "branch2",
                           "provider": ["company_name": "Company Name", "company_code": "CC"],
                           "location": ["latitude": 35.07057, "longitude": -114.58937],
                           "address": ["line1": "Line1", "line2": "Line2", "city": "City", "region": "ST", "country": "US"]]
        do {
            provider1 = try RentalProvider(json: json1)
            provider2 = try RentalProvider(json: json2)
        } catch let error {
            print(error)
            XCTAssert(false)
        }
    }
    
    override func tearDown() {
        provider1 = nil
        provider2 = nil
        super.tearDown()
    }
    
    func testProviderFullAddressFormat()
    {
        // If:
        provider1.addressLineOne = "Line1"
        provider1.addressLineTwo = "Line2"
        provider1.city = "City"
        provider1.state = "ST"
        provider1.country = "US"
        
        // When:
        let calculatedfullAddress = provider1.fullAddress()
        
        // Then:
        let expectedFullAddress = "Line1 Line2 City, ST"
        XCTAssertEqual(calculatedfullAddress, expectedFullAddress, "Address formatted improperly")
    }
    
    func testProviderEquality()
    {
        // When:
        provider1.branchId = "branch1"
        provider2.branchId = "branch1"
        
        // Then:
        let isEqual = provider1.isSameBranchAs(rentalProvider: provider2)
        XCTAssert(isEqual, "Equality not correctly determined.")
    }
    
    func testProviderInequality()
    {
        // When:
        provider1.branchId = "branch1"
        provider2.branchId = "branch2"
        
        // Then:
        let isEqual = provider1.isSameBranchAs(rentalProvider: provider2)
        XCTAssertFalse(isEqual, "Equality not correctly determined.")
    }
    
    func testDistanceFromOtherLocation()
    {
        // If:
        provider1.locationLatitude = 35.23097
        provider1.locationLongitude = -114.03685
        let centralLocation = CLLocation(latitude: 35.07057, longitude: -114.58937)
        
        // When:
        let calculatedMiles = provider1.distanceAwayFrom(location: centralLocation)
        
        // Then:
        let expectedMiles:Double = 33.180242134826
        XCTAssertEqual(calculatedMiles, expectedMiles, accuracy: 0.001)
    }
    
}
