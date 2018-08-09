//
//  UIView+GHBCarRental.swift
//  GHBCarRental
//
//  Created by George Brickley on 8/6/18.
//  Copyright © 2018 George Brickley. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    /// Adds a border to the view
    func setBorder(thickness: CGFloat, color: UIColor, radius: CGFloat)
    {
        self.clipsToBounds = true
        self.layer.borderWidth = thickness
        self.layer.borderColor = color.cgColor
        self.layer.cornerRadius = radius
    }
}
