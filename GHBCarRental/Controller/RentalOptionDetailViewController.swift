//
//  RentalOptionDetailViewController.swift
//  GHBCarRental
//
//  Created by George Brickley on 8/7/18.
//  Copyright © 2018 George Brickley. All rights reserved.
//
// IMPORTANT: This view requires a non-nil `car` property.
//  The safest way to instantiate an instance of this view is to the use the
//  RentailOptionDetailViewFactory's detailViewForCar(:) function.

import UIKit
import CoreLocation
import MapKit

protocol RentalOptionDetailViewDelegate: class {
    // Called when the rental option detail view wants to close
    func rentalOptionsViewDidReuqestToClose(view: RentalOptionDetailViewController)
}

class RentalOptionDetailViewController: UIViewController {
    
    // The car we're displaying details for
    // This is a required property in order to display the view
    var car: RentalCar!
    
    // The views delegate.
    // This is a required property in order to use the view
    weak var delegate: RentalOptionDetailViewDelegate!
    
    // The users center point.  We'll use this location when showing directions.
    var centerPoint: CLPlacemark?
    
    
    var mapView = MKMapView()
    
    // UI Elements
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var providerImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var distanceAwayLabel: UILabel!
    @IBOutlet weak var fullDescriptionLabel: UILabel!
    
    @IBOutlet weak var featureContainer1: UIView!
    @IBOutlet weak var featureLabel1: UILabel!
    
    @IBOutlet weak var featureContainer2: UIView!
    @IBOutlet weak var featureLabel2: UILabel!
    
    @IBOutlet weak var featureContainer3: UIView!
    @IBOutlet weak var featureLabel3: UILabel!
    
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var startNavigationBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialViewSetup()
    }

    func initialViewSetup()
    {
        carImageView.image = car.representativeImage()
        providerImageView.image = car.provider.companyLogo()
        priceLabel.text = car.priceCurrencyString()
        setFeatures(car.features())
        setFullDescriptionText()
        descriptionLabel.text = "\(car.provider.companyName)"
        
        var details = "\(car.provider.streetAddress())"
        
        // TODO: Decide if we want to use search center or users current location
        /*
        if let location = UserLocationManager.sharedInstance.usersCurrentLocation() {
            let distance = car.provider.distanceAwayStringFrom(location: location)
            details += " - \(distance) away"
        }*/
        
        if let location = centerPoint?.location {
            let distance = car.provider.distanceAwayStringFrom(location: location)
            details += " - \(distance) away"
        }
        
        distanceAwayLabel.text = details
    }
    
    func setFeatures(_ features: Array<String>)
    {
        if features.count > 0 {
            featureLabel1.text = features[0]
            featureContainer1.isHidden = false
        } else {
            featureContainer1.isHidden = true
        }
        
        if features.count > 1 {
            featureLabel2.text = features[1]
            featureContainer2.isHidden = false
        } else {
            featureContainer2.isHidden = true
        }
        
        if features.count > 2 {
            featureLabel3.text = features[2]
            featureContainer3.isHidden = false
        } else {
            featureContainer3.isHidden = true
        }
    }
    
    func setFullDescriptionText()
    {
        // TODO: ADD IN REAL TEXT WHEN AVAILABLE
        let capitalizedName = car.provider.companyName.lowercased().capitalized
        let descrip = "This high quality rental car from \(capitalizedName) is waiting for you! Give us a call or visit our website for details."
        fullDescriptionLabel.text = descrip
    }
    
    func presentNavigationOptions()
    {
        // Give the user the option to navigate from the chosen center point or from their current location
        
        print("Present navigation.")
    }
    
    func close()
    {
        delegate.rentalOptionsViewDidReuqestToClose(view: self)
    }
    

    func presentNavigation()
    {
        let coordinate = CLLocationCoordinate2DMake(car.provider.locationLatitude, car.provider.locationLongitude)
        let name = car.provider.companyName
        UserLocationManager.sharedInstance.presentDrivingDirectionsTo(place: name, atCoordinate: coordinate)
    }
    
    
    @IBAction func didRequestToStartNavigation(_ sender: Any)
    {
        presentNavigation()
    }
    
    @IBAction func didRequestToClose(_ sender: Any)
    {
        close()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
