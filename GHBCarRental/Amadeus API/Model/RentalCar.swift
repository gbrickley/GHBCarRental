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
    
    /// The cars transmission type
    var acrissCode: String
    
    /// The cars transmission type
    var transmissionType: String?

    // The estimated price of the rental
    var totalPrice: String
    var currencyType: String
    
    public func priceString()
    {
        
    }
    
    
    enum PropertyKey: String {
        case carInfo = "vehicle_info"
        case acrissCode = "acriss_code"
        case transmissionType = "transmission"
        case estimatedTotal = "estimated_total"
        case totalPrice = "amount"
        case currencyType = "currency"
    }
    
    required init(object: JSONObject<PropertyKey>) throws {
        acrissCode = try object.value(for: .carInfo, .acrissCode)
        transmissionType = try object.value(for: .carInfo, .transmissionType)
        totalPrice = try object.value(for: .estimatedTotal, .totalPrice)
        currencyType = try object.value(for: .estimatedTotal, .currencyType)
    }
    
    func printData()
    {
        print("___________________________________________________________")
        print("Accriss Code: \(acrissCode)")
        print("Transmission Type: \(String(describing: transmissionType))")
        print("Total Price: \(totalPrice)")
        print("Currency Type: \(currencyType)")
        provider.printData()
        print("___________________________________________________________")
    }
}
