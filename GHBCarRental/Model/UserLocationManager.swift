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
    
    // Singleton instance
    static let sharedInstance = UserLocationManager()
    
    // The location manager helps us get access to the users location
    var locationManager = CLLocationManager()
    
    // How accurately we want to grab the users location
    var locationAccuracy: CLLocationAccuracy = kCLLocationAccuracyHundredMeters
    
    // Before we ask for location permission in
    var preAuthorizationMessage: String = Strings.locationPreAuthorizationMessage
    
    // Store a reference to the callback block to execute once we grab the users location
    fileprivate var locationFetchCallback: UserLocationCompletionBlock?
    
    /// Block used to return data about the user current location
    typealias UserLocationCompletionBlock = (_ currentLocation: CLPlacemark?, _ error: String?) -> Void
    
    
    // MARK: Public Methods
    
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
     Presents directions to a given coordinate in the Maps app.
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
        print("[Location Manager]: Handle auth status: \(status)")
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
        print("[Location Manager]: Start updating users location!")
        locationManager.startUpdatingLocation()
    }
    
    private func returnUsersLocation(_ location: CLPlacemark)
    {
        print("[Location Manager]: Return with location: \(location)")
        print("[Location Manager]: Callback block: \(String(describing: locationFetchCallback))")
        if let callback = locationFetchCallback {
            callback(location,nil)
            locationFetchCallback = nil
        }
    }
    
    private func returnUsersLocationWithError(_ error: String)
    {
        print("[Location Manager]: Return with error: \(error)")
        print("[Location Manager]: Callback block: \(String(describing: locationFetchCallback))")
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
            
            print("[Location Manager]: Did retrieve geocoded location: \(String(describing: placemarks))")
            if let placemarks = placemarks, placemarks.count > 0 {
                let placemark = placemarks[0]
                self.returnUsersLocation(placemark)
            } else {
                self.returnUsersLocationWithError(error?.localizedDescription ?? "Unknown error.")
            }
        })
    }
}


extension UserLocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        print("[Location Manager]: Did change authorization status: \(status)")
        handleAuthorizationStatus(status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("[Location Manager]: Did update location: \(locations)")
        let lastLocation = locations.last!
        retrievePlacemarkFromLocation(lastLocation)
        
        // For now, we will stop monitoring location updates.  In a real app, this may be a good way to
        // automatically update the data whenever the users location changes.
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("[Location Manager]: Did fail with error: \(error)")
        returnUsersLocationWithError(error.localizedDescription)
    }
}
