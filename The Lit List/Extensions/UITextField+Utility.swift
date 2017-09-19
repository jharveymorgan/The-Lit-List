//
//  UITextField+Utility.swift
//  The Lit List
//
//  Created by Jordan Harvey-Morgan on 7/12/17.
//  Copyright © 2017 Jordan Harvey-Morgan. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    func configureBorder() {
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    func configurePlaceholderText(placeholderText: String) {
        self.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont(name: "SourceSansPro-SemiBold", size: 15)!])
    }
}
