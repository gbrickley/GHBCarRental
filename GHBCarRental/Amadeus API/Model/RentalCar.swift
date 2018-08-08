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
    
    // The cars fuel type.  May be 'Unspecified' if not known.
    var fuelType: String?
    
    // Whether or not the car has air conditioning
    var hasAirConditioning: Bool
    
    // The estimated price of the rental (i.e. '100.25')
    var priceAsString: String
    
    // The currency type of the price (i.e. 'USD')
    var currencyType: String
    
    // Helps decode Acriss codes
    fileprivate let acrissDecoder = AcrissDecoder()
    
    /**
     The rentals estimated price, as a double
     - returns: Double
     */
    public func price() -> Double
    {
        return Double(priceAsString)!
    }
    
    /**
     The rentals estimated price, as a localized currency string (i.e. $150.50)
     - returns: String
     */
    public func priceCurrencyString() -> String
    {
        return price().asLocalizedCurrencyStringWith(currencyCode:currencyType)
    }
    
    /**
     An image representing the type of car.
     - returns: UIImage (500x200px)
     */
    public func representativeImage() -> UIImage
    {
        return acrissDecoder.representativeImageForVehicleWith(acrissCode: acrissCode)
    }
    
    /**
     An array of the cars features, representing by an array of strings.
     - returns: Array<String>
     */
    public func features() -> Array<String>
    {
        var features = [String]()
        
        if let vehicleType = acrissDecoder.vehicleTypeDescriptionFor(acrissCode: acrissCode) {
            features.append(vehicleType)
        }
        if let transmissionType = transmissionType {
            features.append(transmissionType)
        }
        if hasAirConditioning {
            features.append("Air Conditioning")
        }
        if let fuelType = fuelType, fuelType != "Unspecified" {
            features.append(fuelType)
        }
        
        return features
    }
    
    /**
     Prints info about the car.  Useful for debugging.
     */
    public func printData()
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
    
    
    // MARK: - Private
    
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
    
    required init(object: JSONObject<PropertyKey>) throws
    {
        acrissCode = try object.value(for: .carInfo, .acrissCode)
        fuelType = try object.value(for: .carInfo, .fuelType)
        hasAirConditioning = try object.value(for: .carInfo, .hasAirConditioning)
        transmissionType = try object.value(for: .carInfo, .transmissionType)
        priceAsString = try object.value(for: .estimatedTotal, .priceAsString)
        currencyType = try object.value(for: .estimatedTotal, .currencyType)
    }
}
