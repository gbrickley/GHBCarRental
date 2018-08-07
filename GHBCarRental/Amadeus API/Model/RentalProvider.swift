//
//  RentalProvider.swift
//  GHBCarRental
//
//  Created by George Brickley on 8/5/18.
//  Copyright © 2018 George Brickley. All rights reserved.
//

import Foundation
import SwiftyJSONModel
import CoreLocation

class RentalProvider: JSONObjectInitializable {
    
    // We give each provider a unique id so that we can check for equality
    var branchId: String
    
    /// The providers full company name, required for all providers
    var companyName: String
    
    /// The Amadeus 2-character company code of this car rental provider, required for all providers
    var companyCode: String
    
    // The providers location, represented by latitude and longitude
    var locationLatitude: Double
    var locationLongitude: Double
    
    // The providers address
    var addressLineOne: String
    var addressLineTwo: String?
    var city: String
    var state: String
    var country: String
    
    
    /**
     Whether or not two rental provider objects represent the same branch.
     - Parameter rentalProvider: The provider to check against.
     - returns: Bool
     */
    public func isSameBranchAs(rentalProvider: RentalProvider) -> Bool
    {
        return branchId == rentalProvider.branchId
    }
    
    /**
     Whether or not two rental provider objects represent the same company.
     - Parameter rentalProvider: The provider to check against.
     - returns: Bool
     */
    public func isSameCompanyAs(rentalProvider: RentalProvider) -> Bool
    {
        return companyName.lowercased() == rentalProvider.companyName.lowercased() && companyCode.lowercased() == rentalProvider.companyCode.lowercased()
    }
    
    /**
     The address of the provider.
     - returns: String
     */
    public func fullAddress() -> String
    {
        return "\(streetAddress()) \(city), \(state)"
    }
    
    /**
     A brief string representin the address of the provider.
     - returns: String
     */
    public func streetAddress() -> String
    {
        var address = "\(addressLineOne)"
        if let lineTwo = addressLineTwo {
            address += " \(lineTwo)"
        }
        return address
    }
    
    /**
     The distance (in miles) away from a given point.
     - Parameter location: The location to check the distance from.
     - returns: Double
     */
    public func distanceAwayFrom(location: CLLocation) -> Double
    {
        let coordinate₀ = CLLocation(latitude: locationLatitude, longitude: locationLongitude)
        let distanceInMeters = coordinate₀.distance(from: location)
        let unitConverter = UnitConversions()
        let distanceInMiles = unitConverter.milesFrom(meters: distanceInMeters)
        return distanceInMiles
    }
    
    /**
     A string describing how far away the provider is from a given point. (i.e. `1.2 miles`)
     - Parameter location: The location to check the distance from.
     - returns: String
     */
    public func distanceAwayStringFrom(location: CLLocation) -> String
    {
        let distance = distanceAwayFrom(location: location)
        let roundedDistance = distance.roundToPrecision(1)
        let unit = roundedDistance == 1.0 ? "mile" : "miles"
        return "\(roundedDistance) \(unit)"
    }
    
    /**
     The providers company logo.  If none can be found, returns a default icon.
     - returns: UIImage (150x150)
     */
    public func companyLogo() -> UIImage
    {
        let companyName = self.companyName.lowercased()
        let imageName = "rental-provider-\(companyName)"
        if let image = UIImage(named: imageName) {
            return image
        } else {
            return UIImage(named: "rental-provider-default-icon")!
        }
    }
    
    
    enum PropertyKey: String {
        case branchId = "branch_id"
        case provider = "provider"
        case companyName = "company_name"
        case companyCode = "company_code"
        case location = "location"
        case locationLatitude = "latitude"
        case locationLongitude = "longitude"
        case address = "address"
        case addressLineOne = "line1"
        case addressLineTwo = "line2"
        case city = "city"
        case state = "region"
        case country = "country"
    }
    
    required init(object: JSONObject<PropertyKey>) throws {
        branchId = try object.value(for: .branchId)
        companyName = try object.value(for: .provider, .companyName)
        companyCode = try object.value(for: .provider, .companyCode)
        locationLatitude = try object.value(for: .location, .locationLatitude)
        locationLongitude = try object.value(for: .location, .locationLongitude)
        addressLineOne = try object.value(for: .address, .addressLineOne)
        addressLineTwo = try object.value(for: .address, .addressLineTwo)
        city = try object.value(for: .address, .city)
        state = try object.value(for: .address, .state)
        country = try object.value(for: .address, .country)
    }
    
    func printData()
    {
        print("Branch Id: \(branchId)")
        print("Company Name: \(companyName)")
        print("Company Code: \(companyCode)")
        print("Latitude: \(locationLatitude)")
        print("Longitude: \(locationLongitude)")
        print("Address Line One: \(addressLineOne) |")
        print("Address Line Two: \(String(describing: addressLineTwo))")
        print("City: \(city)")
        print("State: \(state)")
        print("Country: \(country)")
        print(fullAddress())
        let centralLocation = CLLocation(latitude: 35.07057, longitude: -114.58937)
        print(distanceAwayFrom(location: centralLocation))
    }
}
