//
//  MapViewController.swift
//  GHBCarRental
//
//  Created by George Brickley on 8/8/18.
//  Copyright © 2018 George Brickley. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

protocol MapViewDelegate: class {
    // Called when the map view wants to close
    func mapViewDidRequestToClose(view: MapViewController)
}

class MapViewController: UIViewController {
    
    // The rental car options we're displaying on the map
    var cars = [RentalCar]()
    
    // The views delegate.
    // This is a required property in order to use the view
    weak var delegate: MapViewDelegate!
    
    // The user search center point
    var centerPoint: CLPlacemark?
    
    // The rentals pickup date
    var pickupDate: Date?
    
    // The rentals dropoff date
    var dropoffDate: Date?
    
    // UI Elements
    @IBOutlet weak var mapView: MKMapView!
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupMap()
    }
    
    func setupMap()
    {
        /*
        if let centerCoordinate = centerPoint?.location?.coordinate {
            mapView.centerCoordinate = centerCoordinate
        }*/
        self.addAnnotations()
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    func addAnnotations()
    {
        for car in cars
        {
            if let provider = car.provider
            {
                let title = provider.companyName
                let subtitle = "\(car.priceCurrencyString()) - \(provider.streetAddress())"
                let coordinate = CLLocationCoordinate2D(latitude: provider.locationLatitude, longitude: provider.locationLongitude)
                let annot = RentalCarAnnotation(title: title, subtitle: subtitle, coordinate: coordinate, car: car)
                mapView.addAnnotation(annot)
            }
        }
    }
    
    func presentDetailsForCar(_ car: RentalCar)
    {
        let detailView = RentailOptionDetailViewFactory().detailViewForCar(car, usingCenterPoint: centerPoint, withPickupDate: pickupDate, dropoffDate: dropoffDate, andDelegate:self)
        self.present(detailView, animated: true, completion: nil)
    }
    
    @IBAction func didRequestToClose(_ sender: Any)
    {
        close()
    }
    
    func close()
    {
        delegate.mapViewDidRequestToClose(view: self)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}

// MARK: - Map View Delegate
extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        guard let annotation = annotation as? RentalCarAnnotation else {
            return nil
        }
        
        let identifier = "carMarker"
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            // TODO: Decide if we want to display the price in the pin
            //view.glyphText = annotation.car.priceCurrencyString()
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.height, height: view.frame.height))
            imageView.image = annotation.car.provider.companyLogo()
            imageView.contentMode = .scaleAspectFit
            view.leftCalloutAccessoryView = imageView
        }
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl)
    {
        guard let annotation = view.annotation as? RentalCarAnnotation else {
            return
        }
        
        let car = annotation.car
        print("Present details for car: \(car)")
        presentDetailsForCar(car)
    }
}


// MARK: - Rental Details View Delegate
extension MapViewController: RentalOptionDetailViewDelegate {
    
    func rentalOptionsViewDidRequestToClose(view: RentalOptionDetailViewController)
    {
        self.dismiss(animated: true, completion: nil)
    }
}
