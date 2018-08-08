//
//  CarRentalOptionCell.swift
//  GHBCarRental
//
//  Created by George Brickley on 8/6/18.
//  Copyright © 2018 George Brickley. All rights reserved.
//

import UIKit

class CarRentalOptionCell: UITableViewCell {
    
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var providerImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var distanceAwayLabel: UILabel!
    
    @IBOutlet weak var featureContainer1: UIView!
    @IBOutlet weak var featureLabel1: UILabel!
    
    @IBOutlet weak var featureContainer2: UIView!
    @IBOutlet weak var featureLabel2: UILabel!
    
    @IBOutlet weak var featureContainer3: UIView!
    @IBOutlet weak var featureLabel3: UILabel!
    
    /**
     Sets an array of features.
     - Parameter features: The features to set, can be up to 3 features.
     */
    public func setFeatures(_ features: Array<String>)
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
}
