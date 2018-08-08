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
    
    /**
     Creates a new instance of a `MapViewController`.
     - Parameter cars: The cars to display on the map.
     - Parameter centerPoint: The center point of the users search.
     - Parameter pickupDate: The users set pickup date.
     - Parameter dropoffDate: The users set dropoff date.
     - Parameter delegate: The delegate object for the new view.
     - returns: MapViewController
     */
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
