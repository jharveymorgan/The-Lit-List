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
    
    static func configureBackgroundHoki(view: UIView) {
        view.backgroundColor = UIColor(red: 103/255, green: 128/255, blue: 159/255, alpha: 1)
    }
    
    static func configureBackgroundWaxFlower(view: UIView) {
        view.backgroundColor = UIColor(red: 241/255, green: 169/255, blue: 160/255, alpha: 1)
    }
}
