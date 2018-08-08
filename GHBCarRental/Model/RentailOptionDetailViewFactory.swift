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
    
    public func detailViewForCar(_ car: RentalCar, usingCenterPoint centerPoint: CLPlacemark?, andDelegate delegate: RentalOptionDetailViewDelegate) -> RentalOptionDetailViewController
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RentalOptionDetailViewController") as! RentalOptionDetailViewController
        vc.car = car
        vc.delegate = delegate
        vc.centerPoint = centerPoint
        return vc
    }
}

