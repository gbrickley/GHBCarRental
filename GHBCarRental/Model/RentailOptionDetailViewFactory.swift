//
//  RentailOptionDetailViewFactory.swift
//  GHBCarRental
//
//  Created by George Brickley on 8/7/18.
//  Copyright © 2018 George Brickley. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class RentailOptionDetailViewFactory {
    
    /**
     Creates a new instance of a `RentalOptionDetailViewController`.
     - Parameter car: The car to display in the view.
     - Parameter centerPoint: The center point of the users search.
     - Parameter pickupDate: The users set pickup date.
     - Parameter dropoffDate: The users set dropoff date.
     - Parameter delegate: The delegate object for the new view.
     - returns: RentalOptionDetailViewController
     */
    public func detailViewForCar(_ car: RentalCar, usingCenterPoint centerPoint: CLPlacemark?, withPickupDate pickupDate: Date?, dropoffDate: Date?, andDelegate delegate: RentalOptionDetailViewDelegate) -> RentalOptionDetailViewController
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RentalOptionDetailViewController") as! RentalOptionDetailViewController
        vc.car = car
        vc.delegate = delegate
        vc.centerPoint = centerPoint
        vc.pickupDate = pickupDate
        vc.dropoffDate = dropoffDate
        return vc
    }
}

