//
//  SearchViewController.swift
//  GHBCarRental
//
//  Created by George Brickley on 8/5/18.
//  Copyright © 2018 George Brickley. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation

class SearchViewController: UIViewController {
    
    var searchRequest = RentalSearchRequest()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        runTest()
    }
    
    func runTest()
    {
        let request = RentalSearchRequest()
        request.centerPoint = CLLocation(latitude: 35.16553, longitude: -114.55673)
        request.pickUpDate = Date(timeIntervalSince1970: 1533549600)
        request.dropOffDate = Date(timeIntervalSince1970: 1533902400)
        
        request.fetchSearchResults(completion: { result in
            
            switch result {
                
            case .success(let cars):
                for car in cars {
                    car.printData()
                }

            case .error(let code, let description, let moreInfo):
                print("Error [\(code)]: \(description). \(moreInfo)")
            }
        })
        
        
        
        
        /*
        let array = ["Object 1", "Object 2"]
        var arrayCopy = array
        arrayCopy[0] = "Object 1(Updated)"
        print(array)
        print(arrayCopy)
         */
        
        /*
        let json: JSON = ["provider": ["company_name": "Hertz", "company_code": "HZ"], "transmission": "Automatic"]
        //let json: JSON = ["company_code": "AZ"]
        
        do {
            let car = try RentalCar(json: json)
            car.printData()
        } catch let error {
            print(error)
        }*/
        
        /*
        let json: JSON = ["company_name": "Company Name", "company_code": "AZ"]
        //let json: JSON = ["company_code": "AZ"]

        do {
            let provider = try RentalProvider(json: json)
            provider.printData()
        } catch let error {
            print(error)
        }*/
        
        
        
        //print("[Before]: Search radius: \(searchRequest.searchRadius)")
        //print("[Before]: Search request has changed: \(searchRequest.requestHasChangedSinceLastFetch)")
        //searchRequest.searchRadius = 30
        //print("[After]: Search request has changed: \(searchRequest.requestHasChangedSinceLastFetch)")
        //print("[After]: Search radius: \(searchRequest.searchRadius)")
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

}
