//
//  RentalCar.swift
//  GHBCarRental
//
//  Created by George Brickley on 8/5/18.
//  Copyright © 2018 George Brickley. All rights reserved.
//

import Foundation
import SwiftyJSONModel

class RentalCar: JSONObjectInitializable {
    
    /// The cars provider, required for all cars
    var provider: RentalProvider!
    
    /// The 4 letter ACRISS code that defines the properties of car
    var acrissCode: String
    
    /// Car details
    var transmissionType: String?
    var fuelType: String?
    var hasAirConditioning: Bool
    
    // The estimated price of the rental
    var priceAsString: String
    var currencyType: String
    
    public func price() -> Double
    {
        return Double(priceAsString)!
    }
    
    public func priceCurrencyString() -> String
    {
        return price().asLocalizedCurrencyStringWith(currencyCode:currencyType)
    }
    
    
    enum PropertyKey: String {
        case carInfo = "vehicle_info"
        case fuelType = "fuel"
        case hasAirConditioning = "air_conditioning"
        case acrissCode = "acriss_code"
        case transmissionType = "transmission"
        case estimatedTotal = "estimated_total"
        case priceAsString = "amount"
        case currencyType = "currency"
    }
    
    required init(object: JSONObject<PropertyKey>) throws {
        acrissCode = try object.value(for: .carInfo, .acrissCode)
        
        fuelType = try object.value(for: .carInfo, .fuelType)
        hasAirConditioning = try object.value(for: .carInfo, .hasAirConditioning)
        
        transmissionType = try object.value(for: .carInfo, .transmissionType)
        priceAsString = try object.value(for: .estimatedTotal, .priceAsString)
        currencyType = try object.value(for: .estimatedTotal, .currencyType)
    }
    
    func printData()
    {
        print("___________________________________________________________")
        print("Accriss Code: \(acrissCode)")
        print("Transmission Type: \(String(describing: transmissionType))")
        print("Fuel Type: \(String(describing: fuelType))")
        print("Has AC: \(hasAirConditioning)")
        print("Total Price: \(price())")
        print("Currency Type: \(currencyType)")
        provider.printData()
        print("___________________________________________________________")
    }
}
