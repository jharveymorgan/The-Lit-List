//
//  ForgotPasswordViewController.swift
//  The Lit List
//
//  Created by Jordan Harvey-Morgan on 7/12/17.
//  Copyright © 2017 Jordan Harvey-Morgan. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var emailTextField: UITextField!
    
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure navigation bar and view's background
        self.navigationController?.navigationBar.tintColor = UIColor.black
        UINavigationController.configureNavBar(viewController: self)
        UIViewController.configureBackgroundBlueGrey(view: self.view)
        
        // configure back button
        self.navigationItem.hidesBackButton = true
        let backItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-Back Filled-25"), style: .plain, target: self, action: #selector(ForgotPasswordViewController.backButtonTapped))
        self.navigationItem.setLeftBarButton(backItem, animated: true)
        
        // configure textfield
        emailTextField.configureBorder()
        emailTextField.configurePlaceholderText(placeholderText: "EMAIL")
        
        // set textfield delegate
        self.emailTextField.delegate = self
    }
    
    // MARK: - IBActions
    @IBAction func submitButtonTapped(_ sender: Any) {
        // check for empty textfields
        guard let email = emailTextField.text, !email.isEmpty else {
            needInformationAlert()
            return
        }
        
        // send reset link
        UserService.sendResetLink(email: email) { (error) in
            if error != nil {
                self.invalidEmailAlert()
                return
            } else {
                self.resetLinkAlert()
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    // MARK: - Functions
    @objc func backButtonTapped() {
        // dismiss view
        self.navigationController?.popToRootViewController(animated: true)
    }

}

// MARK: - UIAlertController
extension ForgotPasswordViewController {
    func needInformationAlert() {
        let alert = UIAlertController(title: nil, message: "Please enter an email to send the reset password instructions.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(okAction)
        
        self.present(alert, animated: true)
    }
    
    func resetLinkAlert() {
        let alert = UIAlertController(title: nil, message: "Please check your email for instructions on how to reset your password.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(okAction)
        
        self.present(alert, animated: true)
    }
    
    func invalidEmailAlert() {
        let alert = UIAlertController(title: "Invalid Email", message: "Please enter a valid email address.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(okAction)
        
        self.present(alert, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension ForgotPasswordViewController: UITextFieldDelegate {
    // dismiss keyboard when user touches outside
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // if user uses return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        submitButtonTapped(self)
        return true
    }
}
