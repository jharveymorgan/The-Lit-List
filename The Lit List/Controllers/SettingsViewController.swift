//
//  SettingsViewController.swift
//  The Lit List
//
//  Created by Jordan Harvey-Morgan on 7/6/17.
//  Copyright © 2017 Jordan Harvey-Morgan. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {
    // MARK: - Properties
    var authHandle: AuthStateDidChangeListenerHandle?

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
    
    // user wants to sign out
    @IBAction func signOut(_ sender: Any) {
        // sign out current user from firebase
        do {
            try Auth.auth().signOut()
            let initialViewController = UIStoryboard.initialViewController(for: .Onboarding)
            self.view.window?.rootViewController = initialViewController
            self.view.window?.makeKeyAndVisible()
            
        } catch let error as NSError {
            assertionFailure("Error signing out: \(error.localizedDescription)")
        }
    }
    
}
