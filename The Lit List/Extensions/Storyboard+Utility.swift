//
//  Storyboard+Utility.swift
//  The Lit List
//
//  Created by Jordan Harvey-Morgan on 6/29/17.
//  Copyright © 2017 Jordan Harvey-Morgan. All rights reserved.
//

import UIKit

extension UIStoryboard{
    enum LLType: String {
        case Main
        case ItemDetail
        case SearchResult
        case Settings
        case Onboarding
        case Login
        
        var filename: String {
            return rawValue
        }
    }
    
    convenience init(type: LLType, bundle: Bundle? = nil) {
        self.init(name: type.filename, bundle: bundle)
    }
    
    // get initial view controller of specific storyboard
    static func initialViewController(for type: LLType) -> UIViewController {
        let storyboard = UIStoryboard(type: type)
        guard let initialViewController = storyboard.instantiateInitialViewController() else {
            fatalError("Couldn't instantiate view controller for \(type.filename) storyboard.")
        }
        
        return initialViewController
    }
}// end extension
