//
//  RentalCarAnnotationView.swift
//  GHBCarRental
//
//  Created by George Brickley on 8/8/18.
//  Copyright © 2018 George Brickley. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class RentalCarAnnotation: NSObject, MKAnnotation {

    let title: String?
    let subtitle: String?
    let car: RentalCar
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D, car: RentalCar)
    {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.car = car
        super.init()
    }
    
}
