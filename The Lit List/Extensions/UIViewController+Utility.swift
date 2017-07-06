//
//  UIViewController+Utility.swift
//  The Lit List
//
//  Created by Jordan Harvey-Morgan on 6/29/17.
//  Copyright © 2017 Jordan Harvey-Morgan. All rights reserved.
//

import UIKit

extension UIViewController {
    static func configureBackgroundGradient(view: UIView) {
        let backgroundLayer = ColorHelper.backgroundGradient()
        backgroundLayer.frame = view.frame
        view.layer.insertSublayer(backgroundLayer, at: 0)
    }
    
    static func configureBackgroundLightGrey(view: UIView) {
        view.backgroundColor = UIColor(red: 212/255, green: 212/255, blue: 212/255, alpha: 1)
    }
    
    static func configureBackgroundAliceBlue(view: UIView) {
        view.backgroundColor = UIColor(red: 228/255, green: 241/255, blue: 254/255, alpha: 1)
    }
}
