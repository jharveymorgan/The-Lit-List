//
//  SearchByViewController.swift
//  The Lit List
//
//  Created by Jordan Harvey-Morgan on 6/29/17.
//  Copyright © 2017 Jordan Harvey-Morgan. All rights reserved.
//

import UIKit

class SearchByViewController: UIViewController {
    // MARK: - Properties
    
    // MARK: - VC Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIViewController.configureBackgroundGradient(view: self.view)
    }
    
    // MARK: - Function(s)
    
    // MARK: IBActions
    @IBAction func searchButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: Constants.Segue.showResults, sender: self)
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.showResults {
            let navController = segue.destination as! UINavigationController
            let resultsController = navController.topViewController as! ResultsViewController
            resultsController.delegate = self
        }
    }
    
    

}

// MARK: - ResultsViewControllerDelegate
extension SearchByViewController: ResultsViewControllerDelegate {
    // dismiss the results view
    func resultsViewControllerDidCancel(_ controller: ResultsViewController) {
        dismiss(animated: true, completion: nil)
    }
}
