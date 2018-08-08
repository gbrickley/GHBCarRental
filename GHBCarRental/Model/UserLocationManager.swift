//
//  UserLocationManager.swift
//  GHBCarRental
//
//  Created by George Brickley on 8/6/18.
//  Copyright © 2018 George Brickley. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class UserLocationManager: NSObject {
    
    // Always access the location manager through the shared instance
    static let sharedInstance = UserLocationManager()
    
    // The location manager helps us get access to the users location
    var locationManager = CLLocationManager()
    
    // How accurately we want to grab the users location
    var locationAccuracy: CLLocationAccuracy = kCLLocationAccuracyHundredMeters
    
    // Before we ask for location permission, we will prompt the user with a pre-auth message
    var preAuthorizationMessage: String = Strings.locationPreAuthorizationMessage
    
    // Store a reference to the callback block to execute once we grab the users location
    fileprivate var locationFetchCallback: UserLocationCompletionBlock?
    
    /// Block used to return data about the user current location
    typealias UserLocationCompletionBlock = (_ currentLocation: CLPlacemark?, _ error: String?) -> Void
    
    // To make sure the manager is always accessed through the `sharedInstance`
    private override init() {}
    
    
    // MARK: - Public Methods
    
    /**
     Attempts to retrieve the users current location.
     - Parameter UserLocationCompletionBlock: The block to be executed when the request finishes.
     */
    public func fetchUsersCurrentLocation(completion: @escaping UserLocationCompletionBlock)
    {
        locationFetchCallback = completion
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = locationAccuracy
            locationManager.delegate = self
            handleAuthorizationStatus(CLLocationManager.authorizationStatus())
        } else {
            returnUsersLocationWithError("Location services are not available on this device.")
        }
    }
    
    /**
     Presents driving directions to a given coordinate in the Maps app.
     - Parameter place: A description of the location we'll be directing to.
     - Parameter coordinate: The coordinate of the destination to direct to.
     */
    public func presentDrivingDirectionsTo(place: String?, atCoordinate coordinate: CLLocationCoordinate2D)
    {
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = place
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
}


// MARK: Private Methods
private extension UserLocationManager {
    
    private func requestAuthorizationToAccessUsersLocation()
    {
        let alert = UIAlertController(title: "Location Access", message:
            preAuthorizationMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
            self.locationManager.requestWhenInUseAuthorization()
        }))
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    private func handleAuthorizationStatus(_ status: CLAuthorizationStatus)
    {
        switch status {
        case .notDetermined:
            requestAuthorizationToAccessUsersLocation()
            break
            
        case .restricted, .denied:
            let error = "App does not have permission to access location."
            returnUsersLocationWithError(error)
            break
            
        case .authorizedWhenInUse, .authorizedAlways:
            startUpdatingUsersLocation()
            break
        }
    }
    
    private func startUpdatingUsersLocation()
    {
        locationManager.startUpdatingLocation()
    }
    
    private func returnUsersLocation(_ location: CLPlacemark)
    {
        if let callback = locationFetchCallback {
            callback(location,nil)
            locationFetchCallback = nil
        }
    }
    
    private func returnUsersLocationWithError(_ error: String)
    {
        if let callback = locationFetchCallback {
            callback(nil,error)
            locationFetchCallback = nil
        }
    }
    
    private func retrievePlacemarkFromLocation(_ location: CLLocation)
    {
        let geocoder = CLGeocoder()
        
        // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            if let placemarks = placemarks, placemarks.count > 0 {
                let placemark = placemarks[0]
                self.returnUsersLocation(placemark)
            } else {
                self.returnUsersLocationWithError(error?.localizedDescription ?? "Unknown error.")
            }
        })
    }
}


// MARK: - CLLocationManagerDelegate
extension UserLocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        handleAuthorizationStatus(status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let lastLocation = locations.last!
        retrievePlacemarkFromLocation(lastLocation)
        
        // For now, we will stop monitoring location updates.  In a real app, this may be a good way to
        // automatically update the data whenever the users location changes.
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        returnUsersLocationWithError(error.localizedDescription)
    }
}
