//
//  Test.swift
//  GHBCarRental
//
//  Created by George Brickley on 8/10/18.
//  Copyright © 2018 George Brickley. All rights reserved.
//

import Foundation


class CollatzConjecture {
    
    func maxStepCountForSet(startingAt lowerBound: Int, endingBefore upperBound: Int) -> Int
    {
        guard lowerBound > 0, upperBound > lowerBound+1 else {
            return 0
        }
        
        var maxSteps = 0
        var cachedStepsByValue: [Int: Int] = [:]
        
        // This var will store the number of steps each
        var stepCount = 0
        
        for i in lowerBound..<upperBound {
            
            var value = i
            stepCount = 0
            
            // Run through the Collatz conjecture until we reach 1
            while value != 1 {
                stepCount = stepCount + 1
                value = (value % 2 == 0) ? value/2 : (3*value)+1
                // Now that we've edited the value, check if we have a cached step count for the new value
                if let cachedStepCount = cachedStepsByValue[value] {
                    stepCount = stepCount + cachedStepCount
                    value = 1
                }
            }
            
            // Cache the calculated step value
            cachedStepsByValue[i] = stepCount
            
            // Check if the calculated step count was greater than the current max
            if stepCount > maxSteps {
                maxSteps = stepCount
            }
        }
    
        return maxSteps
    }
}
