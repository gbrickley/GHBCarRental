//
//  RentalSearchRequest.swift
//  GHBCarRental
//
//  Created by George Brickley on 8/5/18.
//  Copyright © 2018 George Brickley. All rights reserved.
//

import Foundation
import CoreLocation

/// Options available for ordering the search results
enum ResultsOrderType {
    /// The results will be ordered from closest to the center point
    case proximity
    /// The results will be ordered by price, low to high, and then secondly by proximity
    case priceLowToHigh
    /// The results will be ordered by price, high to low, and then secondly by proximity
    case priceHighToLow
}

class RentalSearchRequest {
    
    /// The location at which to center the search, required to successfully search
    var centerPoint: CLPlacemark? {
        didSet {
            didChangeServerBasedSearchParameter()
        }
    }
    
    /// The radius, in miles, to search for rental cars within
    var searchRadius: Int = DefaultSearchParameters.radius {
        didSet {
            didChangeServerBasedSearchParameter()
        }
    }
    
    /// The date the user wants to pick up the rental, required to successfully search
    var pickUpDate: Date? {
        didSet {
            didChangeServerBasedSearchParameter()
        }
    }
    
    /// The date the user wants to drop off the rental, required to successfully search
    var dropOffDate: Date? {
        didSet {
            didChangeServerBasedSearchParameter()
        }
    }
        
    /**
     How to order the search resuls.  Defaults to `priceLowToHigh`. Once applying an order type, you should still retrieve results using the fetchResults(:) method.
     Developer note: For now, ordering is done on the client, so no need to retrieve new data from the server when this changes.
     */
    var resultsOrderType: ResultsOrderType = ResultsOrderType.priceLowToHigh
    
    /**
     An optional filter that will show only results from the given rental provider. After applying this filter, you should still retrieve results using the fetchResults(:) method.
     Developer note: For now, filtering is done on the client so no need to retrieve new data from the server when this changes.
     */
    var rentalProviderFilter: RentalProvider?
    
    /**
     A unique array of providers that can be used to filer the search results, ordered alphabetically by company name.
     - returns: Array<RentalProvider>
     */
    public func rentalProviderFilterOptions() -> Array<RentalProvider>
    {
        guard let results = results else {
            return []
        }
        
        var uniqueProviders = [RentalProvider]()
        for car in results {
            if ( !providerArray(uniqueProviders, contains: car.provider) ) {
                uniqueProviders.append(car.provider)
            }
        }
        
        // Now sort alphabetically by company name
        return uniqueProviders.sorted{ $0.companyName < $1.companyName }
    }
    
    private func providerArray(_ providers: Array<RentalProvider>, contains provider: RentalProvider ) -> Bool
    {
        for existingProvider in providers {
            if (existingProvider.isSameCompanyAs(rentalProvider: provider)) {
                return true
            }
        }
        return false
    }
    
    
    
    /**
     Whether or not all of the required properties are set to make a successful search request.
     - returns: Bool
     */
    public func isValid() -> Bool
    {
        // These are the minimum required values in order to search
        return centerPoint != nil && pickUpDate != nil && dropOffDate != nil
    }
    

    /**
     Retreieves search results for the current state of the search request.
     - Parameter rentalSearchCompletionBlock: The block to be executed when the request finishes. If the request is successful, an array of `RentalCar` objects will be returned.
     */
    public func fetchSearchResults(completion: @escaping rentalSearchCompletionBlock)
    {
        // A center point for the search is required
        guard centerPoint != nil else {
            let descrip = "A center point for the search is required."
            let cause = "No center point set for the request"
            completion(Result.error(code: 450, description: descrip, moreInfo: cause))
            return
        }
        
        // A pickup date for the search is required
        guard let pickUpDate = pickUpDate else {
            let descrip = "A pickup date is required."
            let cause = "No pickup date set for the request"
            completion(Result.error(code: 451, description: descrip, moreInfo: cause))
            return
        }
        
        // A dropoff date for the search is required
        guard let dropOffDate = dropOffDate else {
            let descrip = "A dropoff date is required."
            let cause = "No dropoff date set for the request"
            completion(Result.error(code: 452, description: descrip, moreInfo: cause))
            return
        }
        
        // A dropoff date for the search is required
        guard dropOffDate > pickUpDate else {
            let descrip = "The dropoff date must be after the pick date."
            let cause = "Dropoff date is before pickup date"
            completion(Result.error(code: 453, description: descrip, moreInfo: cause))
            return
        }
        
        fetchAllSeachResults(completion: { response in
            
            switch response {
            case .success(let rentalCars):
                // Save the cars and then apply the filers and sorting
                self.results = rentalCars
                let filteredResults = self.filteredAndSortedResults()
                self.requestHasChangedSinceLastFetch = false
                completion(Result.success(filteredResults))
                
            case .error(let code, let friendlyMessage, let cause):
                completion(Result.error(code: code, description: friendlyMessage, moreInfo: cause))
            }
        })
    }

    private func fetchAllSeachResults(completion: @escaping rentalSearchCompletionBlock)
    {
        // If we have saved valid results, no need to fetch from the server
        // If not, fetch the results from the server
        print("[API]: Fetching all search results")
        print("[API]: Server based params have changed: \(requestHasChangedSinceLastFetch)")
        print("[API]: Current results count: \(results?.count ?? 0)")
        
        if let resultsCopy = results, resultsCopy.count > 0, !requestHasChangedSinceLastFetch {
            print("[API]: We have a valid cached result array, return that right away")
            completion(Result.success(resultsCopy))
        } else {
            print("[API]: Refresh data from server")
            let search = CarRentalGeosearch()
            search.fetchResultsFor(searchRequest:self, completion: { response in
                completion(response)
            })
        }
    }
    
    
    /// Whether or not the request params have changed since the last time we fetched results
    fileprivate var requestHasChangedSinceLastFetch: Bool = false
    
    /**
     The results of the last result fetch.  If none of the 'server based' search parameters have changed since the last result fetch, this will contain the results.  Note, this array will always contain the 'non-filtered' and 'non-ordered' search results.  The filtered and ordered results should be retrieved from the fetchResults(:) method.
     */
    fileprivate var results:[RentalCar]?
    
    
    /// Should be called anytime
    private func didChangeServerBasedSearchParameter()
    {
        requestHasChangedSinceLastFetch = true
        results = nil
    }

    private func filteredAndSortedResults() -> Array<RentalCar>
    {
        guard let results = results else {
            return []
        }
        let filteredResults = self.applyFilters(to: results)
        let orderedResults = self.applyOrdering(to: filteredResults)
        return orderedResults
    }
    
    /// Applies any of the set filters to the results data set
    private func applyFilters(to results: Array<RentalCar>) -> Array<RentalCar>
    {
        var filteredArray = results
        
        // Apply the rental provider filter if we have one
        if let rentalProviderFilter = rentalProviderFilter {
            filteredArray = filteredArray.filter {
                return $0.provider.isSameCompanyAs(rentalProvider: rentalProviderFilter)
            }
        }

        return filteredArray
    }
    
    /// Applies the chosen ordering to the results data set
    private func applyOrdering(to results: Array<RentalCar>) -> Array<RentalCar>
    {
        var orderedResults = results
        
        switch resultsOrderType {
            
        case ResultsOrderType.priceHighToLow:
            orderedResults.sort {
                let price1 = $0.price()
                let price2 = $1.price()
                
                if let centerPoint = centerPoint, price1 == price2 {
                    let distance1 = $0.provider.distanceAwayFrom(location: centerPoint.location!)
                    let distance2 = $1.provider.distanceAwayFrom(location: centerPoint.location!)
                    return distance1 < distance2
                } else {
                    return $0.price() > $1.price()
                }
            }
        
        case ResultsOrderType.priceLowToHigh:
            orderedResults.sort {
                let price1 = $0.price()
                let price2 = $1.price()
                
                if let centerPoint = centerPoint, price1 == price2 {
                    let distance1 = $0.provider.distanceAwayFrom(location: centerPoint.location!)
                    let distance2 = $1.provider.distanceAwayFrom(location: centerPoint.location!)
                    return distance1 < distance2
                } else {
                    return $0.price() < $1.price()
                }
            }
            
        case ResultsOrderType.proximity:
            if let centerPoint = centerPoint {
                orderedResults.sort {
                    let distance1 = $0.provider.distanceAwayFrom(location: centerPoint.location!)
                    let distance2 = $1.provider.distanceAwayFrom(location: centerPoint.location!)
                    // If the distance is the same, sort by price
                    if (distance1 == distance2) {
                        return $0.price() < $1.price()
                    } else {
                        return distance1 < distance2
                    }
                }
            }
        }
        
        return orderedResults
    }
}
