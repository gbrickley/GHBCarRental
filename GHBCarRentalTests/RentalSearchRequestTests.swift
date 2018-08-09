//
//  RentalSearchRequestTests.swift
//  GHBCarRentalTests
//
//  Created by George Brickley on 8/8/18.
//  Copyright © 2018 George Brickley. All rights reserved.
//

import XCTest
import OHHTTPStubs
import CoreLocation
import MapKit
import AddressBook
import Contacts
import SwiftyJSON
import SwiftyJSONModel
@testable import GHBCarRental

class RentalSearchRequestTests: XCTestCase {
    
    // The object under test
    var rentalSearchRequest: RentalSearchRequest!
    
    // The host we're stubbing in the API requests
    let testHost = "api.sandbox.amadeus.com"
    
    override func setUp()
    {
        super.setUp()
        rentalSearchRequest = RentalSearchRequest()
    }
    
    override func tearDown()
    {
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    func validSearchRequest() -> RentalSearchRequest
    {
        let searchRequest = RentalSearchRequest()
        
        // Cannot create CLPlacemarks directly, so using a sub class MKPlacemark
        let coordinate = CLLocationCoordinate2D(latitude: 35.1504, longitude: -114.57632)
        let address = ["City": "Palo Alto", CNPostalAddress().state: "CA"] as [String : Any]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: address)
        searchRequest.centerPoint = placemark
        
        let today = Date()
        searchRequest.pickUpDate = Calendar.current.date(byAdding: .day, value: 1, to: today)
        searchRequest.dropOffDate = Calendar.current.date(byAdding: .day, value: 3, to: today)
        
        return searchRequest
    }    
    
    func testSearchRequestResultCount()
    {
        // Setup network stubs
        let jsonDataFile = "car_rental_geosearch_success.json"

        stub(condition: isHost(testHost)) { _ in
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile(jsonDataFile, type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type":"application/json"]
            )
        }
        
        // Setup what should be a successful request
        let searchRequest = validSearchRequest()

        // Set expectations
        let expectedCarCount = 27
        let expectation = self.expectation(description: "calls the callback with response")
        
        searchRequest.fetchSearchResults(completion: { result in
            
            print("[Test]: Response: \(result)")
            switch result {
                
            case .success(let cars):
                let count = cars.count
                print("[Test]: Car count: \(count)")
                XCTAssertEqual(cars.count, expectedCarCount, "Returned error code")

            case .error(let code, let description, let moreInfo):
                print("Error [\(code)]: \(description). \(moreInfo)")
                XCTAssert(false, "Returned error code")
            }
            
            expectation.fulfill()
        })
        
        self.waitForExpectations(timeout: 0.3, handler: .none)
    }
    
    
    func testSearchRequestErrorHandling()
    {
        // Setup network stubs
        let jsonDataFile = "car_rental_geosearch_failure.json"
        
        stub(condition: isHost(testHost)) { _ in
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile(jsonDataFile, type(of: self))!,
                statusCode: 400,
                headers: ["Content-Type":"application/json"]
            )
        }
        
        // Setup what should be a successful request
        let searchRequest = validSearchRequest()
        
        // Set expectations
        let expectedErrorCode = 451
        let expectation = self.expectation(description: "calls the callback with response")
        
        searchRequest.fetchSearchResults(completion: { result in
            
            print("[Test]: Response: \(result)")
            switch result {
                
            case .success( _):
                XCTAssert(false, "Request returned success instead of error.")
                
            case .error(let code, let description, let moreInfo):
                print("Error [\(code)]: \(description). \(moreInfo)")
                XCTAssertEqual(code, expectedErrorCode, "Returned incorrect error code of \(code)")
            }
            
            expectation.fulfill()
        })
        
        self.waitForExpectations(timeout: 0.3, handler: .none)
    }
    
    
    func testSearchRequestProviderFilter()
    {
        // Setup network stubs
        let jsonDataFile = "car_rental_geosearch_success.json"
        
        stub(condition: isHost(testHost)) { _ in
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile(jsonDataFile, type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type":"application/json"]
            )
        }
        
        // Setup what should be a successful request
        let searchRequest = validSearchRequest()
        
        let json: JSON = ["provider": ["company_code": "ZI", "company_name": "AVIS"], "branch_id": "IFPT01", "location": ["latitude": 35.15, "longitude": -114.5567], "address": ["line1": "LAUGHLIN/BULLHEAD INT L APO", "city": "BULLHEAD CITY", "region": "AZ", "country": "US"]]
        
        do {
            let provider = try RentalProvider(json: json)
            searchRequest.rentalProviderFilter = provider
        } catch let error {
            print(error)
            XCTAssert(false, "Failed to create fake provider object. \(error.localizedDescription)")
            return
        }
        
        // Set expectations
        let expectedCompanyName = "AVIS"
        let expectation = self.expectation(description: "calls the callback with response")
        
        searchRequest.fetchSearchResults(completion: { result in
            
            switch result {
                
            case .success(let cars):
                
                if cars.count == 0 {
                    XCTAssert(false, "Fetch did not return any results.")
                }
                
                for car in cars {
                    let computedCompanyName = car.provider!.companyName
                    XCTAssertEqual(computedCompanyName, expectedCompanyName, "Company with name: \(computedCompanyName) does not belong in the results.")
                }
                
            case .error(let code, let description, let moreInfo):
                print("Error [\(code)]: \(description). \(moreInfo)")
                XCTAssert(false, "Returned error code")
            }
            
            expectation.fulfill()
        })
        
        self.waitForExpectations(timeout: 0.3, handler: .none)
    }
    
    
    func testSearchRequestOrderingTypeProximity()
    {
        // Setup network stubs
        let jsonDataFile = "car_rental_geosearch_success.json"
        
        stub(condition: isHost(testHost)) { _ in
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile(jsonDataFile, type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type":"application/json"]
            )
        }
        
        // Setup what should be a successful request
        let searchRequest = validSearchRequest()
        searchRequest.resultsOrderType = .proximity
        
        // Set expectations
        let expectedLatLongCar1 = "35.15,-114.5567"
        let expectedLatLongCar2 = "35.15,-114.5567"
        let expectedLatLongCar3 = "35.16553,-114.55673"
        let expectation = self.expectation(description: "calls the callback with response")
        
        searchRequest.fetchSearchResults(completion: { result in

            switch result {
                
            case .success(let cars):

                if cars.count < 3 {
                    XCTAssert(false, "Not enough results returned to validate test.")
                } else {
                    // Grab the latitudes and longitudes
                    let providerCar1 = cars[0].provider!
                    let providerCar2 = cars[1].provider!
                    let providerCar3 = cars.last!.provider!
                    
                    let latLongCar1 = "\(providerCar1.locationLatitude),\(providerCar1.locationLongitude)"
                    let latLongCar2 = "\(providerCar2.locationLatitude),\(providerCar2.locationLongitude)"
                    let latLongCar3 = "\(providerCar3.locationLatitude),\(providerCar3.locationLongitude)"
                    
                    XCTAssertEqual(latLongCar1, expectedLatLongCar1, "First car in the list was wrong.")
                    XCTAssertEqual(latLongCar2, expectedLatLongCar2, "Second car in the list was wrong.")
                    XCTAssertEqual(latLongCar3, expectedLatLongCar3, "Last car in the list was wrong.")
                }

            case .error(let code, let description, let moreInfo):
                print("Error [\(code)]: \(description). \(moreInfo)")
                XCTAssert(false, "Returned error code")
            }
            
            expectation.fulfill()
        })
        
        self.waitForExpectations(timeout: 0.3, handler: .none)
    }
}
