//
//  UIViewController+Utility.swift
//  The Lit List
//
//  Created by Jordan Harvey-Morgan on 6/29/17.
//  Copyright © 2017 Jordan Harvey-Morgan. All rights reserved.
//

import UIKit

extension UIViewController {
    static func configureBackgroundColor(view: UIView) {
        // background color
        let backgroundLayer = ColorHelper.backgroundGradient()
        backgroundLayer.frame = view.frame
        view.layer.insertSublayer(backgroundLayer, at: 0)
    }
}
