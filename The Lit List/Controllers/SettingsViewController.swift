//
//  SettingsViewController.swift
//  The Lit List
//
//  Created by Jordan Harvey-Morgan on 7/6/17.
//  Copyright © 2017 Jordan Harvey-Morgan. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    // MARK: - VC Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()

        UIViewController.configureBackgroundAliceBlue(view: self.view)
    }

    // MARK: - IBActions
    
    // icons8 link for licensing
    @IBAction func icons8ButtonTapped(_ sender: Any) {
        let icons8Link = "https://icons8.com/"
        UIApplication.shared.open(URL(string: icons8Link)!, options: [:], completionHandler: nil)
    }
    // user wants to provide feedback
    @IBAction func feedbackButtonTapped(_ sender: Any) {
        let email = "TheLitListApp@gmail.com"
        UIApplication.shared.open(URL(string: "mailto:\(email)")!, options: [:], completionHandler: nil)
    }
    
}
