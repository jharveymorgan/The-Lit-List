//
//  ResultDetailViewController.swift
//  The Lit List
//
//  Created by Jordan Harvey-Morgan on 6/29/17.
//  Copyright © 2017 Jordan Harvey-Morgan. All rights reserved.
//

import UIKit

class ResultDetailViewController: UIViewController {
    // MARK: - Properties
    
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
        UIViewController.configureBackgroundGradient(view: self.view)
        UINavigationController.configureNavBar(viewController: self)

    }
    
    // MARK: - Functions
    
    // MARK: IBActions
    

}
