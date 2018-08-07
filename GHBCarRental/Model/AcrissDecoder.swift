//
//  AcrissDecoder.swift
//  GHBCarRental
//
//  Created by George Brickley on 8/6/18.
//  Copyright © 2018 George Brickley. All rights reserved.
//

import Foundation
import UIKit

/// Supported vehicle categories
enum VehicleCategory {
    case unknown
    case mini
    case economy
    case compact
    case standard
    case fullsize
    case premium
    case luxury
    case oversize
}


class AcrissDecoder {
    
    // MARK: - Public Methods
    
    /**
     The vehicle category represented by a given Acriss code
     - Parameter acrissCode: The acriss code to decode.
     - returns: VehicleCategory
     */
    public func vehicleCategoryFor(acrissCode: String?) -> VehicleCategory
    {
        guard let acrissCode = acrissCode, isValidAcrissCode(acrissCode) else {
            return VehicleCategory.unknown
        }
        
        let code = substring(fromString: acrissCode, atIndex: categoryCharcterIndex)

        switch code {
            
        case _ where codesMini.contains(code):
            return VehicleCategory.mini

        case _ where codesEconomy.contains(code):
            return VehicleCategory.economy
            
        case _ where codesCompact.contains(code):
            return VehicleCategory.compact
            
        case _ where codesStandard.contains(code):
            return VehicleCategory.standard
            
        case _ where codesFullsize.contains(code):
            return VehicleCategory.fullsize
            
        case _ where codesPremium.contains(code):
            return VehicleCategory.premium
            
        case _ where codesLuxury.contains(code):
            return VehicleCategory.luxury
            
        case _ where codesOversized.contains(code):
            return VehicleCategory.oversize
            
        default:
            return VehicleCategory.unknown
        }
    }
    
    /**
     A (320x160) image representation of the vehicle category denoted by an Acriss code.
     - Parameter acrissCode: The vehicles acriss code.
     - returns: UIImage (320x160)
     */
    public func representativeImageForVehicleWith(acrissCode: String?) -> UIImage
    {
        let category = vehicleCategoryFor(acrissCode: acrissCode)
        return representativeImageFor(vehicleCategory: category)
    }
    
    
    // MARK: Private Properties
    
    // The expected length for an Acriss code
    fileprivate let acrissCodeLenght = 4
    
    /// The index of the Acriss string where the category denoter can be found
    fileprivate let categoryCharcterIndex = 0
    
    // The codes for each category type
    fileprivate let codesMini      = ["M","N"]
    fileprivate let codesEconomy   = ["E","H"]
    fileprivate let codesCompact   = ["C","D"]
    fileprivate let codesStandard  = ["I","J","S","R"]
    fileprivate let codesFullsize  = ["F","G"]
    fileprivate let codesPremium   = ["P","U"]
    fileprivate let codesLuxury    = ["L","W"]
    fileprivate let codesOversized = ["O"]
}


// MARK: - Private Methods
extension AcrissDecoder {
    
    private func isValidAcrissCode(_ acrissCode: String) -> Bool
    {
        return acrissCode.count == 4
    }
    
    private func substring(fromString str: String, atIndex indexOfCharacter: Int) -> String
    {
        let index = str.index(str.startIndex, offsetBy: indexOfCharacter)
        let char = str[index]
        return String(char)
    }
    
    private func representativeImageFor(vehicleCategory: VehicleCategory) -> UIImage
    {
        
        // TODO: USING THIS FOR NOW
        return UIImage(named: "acriss-img-unknown")!
        
        /*
        switch vehicleCategory {
            
        case .unknown:
            return UIImage(named: "acriss-img-unknown")!
            
        case .mini:
            return UIImage(named: "acriss-img-mini")!
            
        case .compact:
            return UIImage(named: "acriss-img-compact")!
            
        case .standard:
            return UIImage(named: "acriss-img-standard")!
            
        case .fullsize:
            return UIImage(named: "acriss-img-fullsize")!
            
        case .premium:
            return UIImage(named: "acriss-img-premium")!
            
        case .luxury:
            return UIImage(named: "acriss-img-luxury")!
            
        case .oversize:
            return UIImage(named: "acriss-img-oversize")!
            
        default:
            return UIImage(named: "acriss-img-unknown")!
        }*/
    }
    
}
