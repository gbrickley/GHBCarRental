//
//  MapViewControllerFactory.swift
//  GHBCarRental
//
//  Created by George Brickley on 8/8/18.
//  Copyright © 2018 George Brickley. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewFactory {
    
    public func mapViewForCars(_ cars: Array<RentalCar>, usingCenterPoint centerPoint: CLPlacemark?, withPickupDate pickupDate: Date?, dropoffDate: Date?, andDelegate delegate: MapViewDelegate) -> MapViewController
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        vc.cars = cars
        vc.delegate = delegate
        vc.centerPoint = centerPoint
        vc.pickupDate = pickupDate
        vc.dropoffDate = dropoffDate
        return vc
    }
}
