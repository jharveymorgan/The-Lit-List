//
//  ItemDetailViewController.swift
//  The Lit List
//
//  Created by Jordan Harvey-Morgan on 6/29/17.
//  Copyright © 2017 Jordan Harvey-Morgan. All rights reserved.
//

import UIKit

class ItemDetailViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure view
        doneButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "SourceSansPro-Bold", size: 19)!], for: .normal)
        UIViewController.configureBackgroundGradient(view: self.view)
        UINavigationController.configureNavBar(viewController: self)
        
    }
    
    // MARK: - Function(s)
    // construct the affiliate link
    func createAffiliateLink(for bookISBN: String) -> String {
        let affiliateLink = "https://geo.itunes.apple.com/us/book/isbn\(bookISBN)?mt=11&at=\(Constants.iTunesAffiliate.affiliateID)"
        return affiliateLink
    }
    
    // MARK: - IBActions
    @IBAction func doneButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
