//
//  LoginViewController.swift
//  The Lit List
//
//  Created by Jordan Harvey-Morgan on 7/12/17.
//  Copyright © 2017 Jordan Harvey-Morgan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure navigation bar and view
        self.navigationController?.navigationBar.tintColor = UIColor.black
        UINavigationController.configureNavBar(viewController: self)
        UIViewController.configureBackgroundBlueGrey(view: self.view)
        
        // configure textfields
        emailTextField.configureBorder()
        emailTextField.configurePlaceholderText(placeholderText: "EMAIL")
        
        passwordTextField.configureBorder()
        passwordTextField.configurePlaceholderText(placeholderText: "PASSWORD")
        
        // set textfield delegate
        self.emailTextField.delegate = self
    }
    
    // MARK: - IBActions
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        // check for empty textfields
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            needInformationAlert()
            return
        }
        
        print("login submit button tapped")
    }

    @IBAction func forgotPasswordTapped(_ sender: Any) {
        print("forgot password button tapped")
    }
    
}

// MARK: - UIAlertController
extension LoginViewController {
    func needInformationAlert() {
        let alert = UIAlertController(title: nil, message: "Please enter an email AND password to log into your.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(okAction)
        
        self.present(alert, animated: true)
    }
}

// MARK: - UITextfieldDelegate
extension LoginViewController: UITextFieldDelegate {
    // dismiss keyboard when user touches outside
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
