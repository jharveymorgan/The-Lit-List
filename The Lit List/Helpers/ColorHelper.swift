//
//  ColorHelper.swift
//  The Lit List
//
//  Created by Jordan Harvey-Morgan on 6/28/17.
//  Copyright © 2017 Jordan Harvey-Morgan. All rights reserved.
//

import UIKit

struct ColorHelper {
    let gradient: CAGradientLayer!
    
    // gradient for main background
    static func  backgroundGradient() -> CAGradientLayer {
        
        let colorTop = UIColor(red: 184/255.0, green: 217/255.0, blue: 255/255.0, alpha: 1).cgColor
        let colorBottom = UIColor(red: 197/255.0, green: 239/255.0, blue: 255/255.0, alpha: 1).cgColor
        
        let gradient = CAGradientLayer()
        gradient.colors = [colorTop, colorBottom]
        gradient.locations = [0.0, 1.0]
        return gradient
    }
}

