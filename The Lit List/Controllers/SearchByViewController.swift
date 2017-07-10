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
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var isbnTextField: UITextField!
    
    // MARK: - VC Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleTextField.delegate = self
        
        // configure background
        UIViewController.configureBackgroundAliceBlue(view: self.view)
        
        // configure placeholder isbn text
        //isbnTextField.attributedPlaceholder = NSAttributedString(string: "9780545582957", attributes: [NSForegroundColorAttributeName: UIColor.black])
    }
    
    // MARK: - Function(s)
    // check user is only searching by one parameter
    func checkFields() throws -> Bool {
        let titleEmpty = titleTextField.text?.isEmpty
        let authorEmpty = authorTextField.text?.isEmpty
        let isbnEmpty = isbnTextField.text?.isEmpty
        
        // if searching by one field, others should be empty
        if titleEmpty == false && (authorEmpty == false || isbnEmpty == false) {
            tooManyParametersAlert()
            throw Constants.SearchError.invalidSearchParameters
        }
        if authorEmpty == false && (titleEmpty == false || isbnEmpty == false) {
            tooManyParametersAlert()
            throw Constants.SearchError.invalidSearchParameters
        }
        if isbnEmpty == false && (authorEmpty == false || titleEmpty == false) {
            tooManyParametersAlert()
            throw Constants.SearchError.invalidSearchParameters
        }
        
        // if no parameters
        if titleEmpty == true && authorEmpty == true && isbnEmpty == true {
            noSearchParametersAlert()
            throw Constants.SearchError.NoSearchParameters
        }
        
        return true
    }
    
    // get user's search parameters
    func getSearchBy() -> String {
        if titleTextField.text?.isEmpty == false {
            return titleTextField.text!
        }
        else if authorTextField.text?.isEmpty == false {
            return authorTextField.text!
        }
        else if isbnTextField.text?.isEmpty == false {
            return isbnTextField.text!
        }
        
        return "Error finding parameters"
    }
    
    // clear text field after search
    func clearTextField() {
        titleTextField.text = nil
        authorTextField.text = nil
        isbnTextField.text = nil
    }
    
    // MARK: IBActions
    @IBAction func searchButtonTapped(_ sender: Any) {
        let proceed = try? checkFields()
        if let _ = proceed {
            performSegue(withIdentifier: Constants.Segue.showResults, sender: self)
        }
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.showResults {
            let search = getSearchBy()
            
            let navController = segue.destination as! UINavigationController
            let resultsController = navController.topViewController as! ResultsViewController
            resultsController.searchParameter = search
            resultsController.delegate = self
            
            clearTextField()
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

// MARK: - AlertController
extension SearchByViewController {
    // alert to tell user to only search by one parameter
    func tooManyParametersAlert() {
        let alert = UIAlertController(title: nil, message: "Please only search by one parameter at a time.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(okAction)
        
        self.present(alert, animated: true)
    }
    
    // alert to search by at least one parameter
    func noSearchParametersAlert() {
        let alert = UIAlertController(title: nil, message: "Please enter one search parameter.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(okAction)
        
        self.present(alert, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension SearchByViewController: UITextFieldDelegate {
    // dismiss keyboard when user touches outside
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
