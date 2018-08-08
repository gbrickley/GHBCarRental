//
//  CarRentalGeosearch.swift
//  GHBCarRental
//
//  Created by George Brickley on 8/5/18.
//  Copyright © 2018 George Brickley. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


/// Block used to return fetched rental car options
typealias rentalSearchCompletionBlock = (Result<[RentalCar]>) -> Void


class CarRentalGeosearch {
    
    /**
     Retreieves search results for a given search request.
     - Parameter searchRequest: The request to process.
     - Parameter rentalSearchCompletionBlock: The block to be executed when the request finishes.
     */
    public func fetchResultsFor(searchRequest: RentalSearchRequest, completion: @escaping rentalSearchCompletionBlock)
    {
        let urlString = "\(AmadeusAPIConstant.baseUrl)/cars/search-circle"
        let url = URL(string: urlString)!

        var params: Parameters = [:]
        params["apikey"] = AmadeusAPIConstant.apiKey
        params["lang"] = AmadeusAPIDefaults.language
        params["currency"] = AmadeusAPIDefaults.currencyType
        
        let converter = UnitConversions()
        let radiusInKilometers = converter.kilometersFrom(miles: searchRequest.searchRadius)
        params["radius"] = Int(round(radiusInKilometers))
        
        if let centerPoint = searchRequest.centerPoint {
            params["latitude"] = centerPoint.location!.coordinate.latitude
            params["longitude"] = centerPoint.location!.coordinate.longitude
        }
        
        if let pickupDate = searchRequest.pickUpDate {
            params["pick_up"] = pickupDate.amadeusAPIFormattedDateTimeString()
        }
        
        if let dropoffDate = searchRequest.dropOffDate {
            params["drop_off"] = dropoffDate.amadeusAPIFormattedDateTimeString()
        }

        Alamofire.request(url, parameters: params).validate().responseJSON { response in

            switch response.result {
                
            case .success(let data):
                let results = self.rentalCarsFromJSON(JSON(data))
                completion(Result.success(results))
            
            case .failure( _):
                // If there was an error, attempt to grab the error message and more info
                var descrip = ""
                var moreInfo = ""
                
                if let data = response.data {
                    let json = JSON(data)
                    if let errorMessage = json["message"].string {
                        descrip = errorMessage
                    }
                    if let details = json["more_info"].string {
                        moreInfo = details
                    }
                } else {
                    descrip = "Unknown error"
                    moreInfo = "Unknown"
                }

                completion(Result.error(code: 451, description: descrip, moreInfo: moreInfo))
            }
        }
    }
}

private extension CarRentalGeosearch {
    
    private func rentalCarsFromJSON(_ json: JSON) -> Array<RentalCar>
    {
        guard let results = json["results"].array else {
            return []
        }
        
        // This will be our array of cars that we'll return
        var allCars = [RentalCar]()
        
        for result in results {
            
            if let provider = rentalProviderFromJSON(result) {
                
                if let cars = result["cars"].array {
                    for car in cars {
                        do {
                            let newCar = try RentalCar(json: car)
                            newCar.provider = provider
                            allCars.append(newCar)
                        } catch let error {
                            print(error)
                        }
                    }
                }
            }
        }
        
        return allCars;
    }
    
    
    private func rentalProviderFromJSON(_ json: JSON) -> RentalProvider?
    {
        do {
            let provider = try RentalProvider(json: json)
            return provider
        } catch let error {
            print(error)
            return nil
        }
    }
}
