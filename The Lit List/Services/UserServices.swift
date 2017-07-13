//
//  UserServices.swift
//  The Lit List
//
//  Created by Jordan Harvey-Morgan on 6/29/17.
//  Copyright © 2017 Jordan Harvey-Morgan. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Firebase
import FirebaseAuth
import FirebaseDatabase

struct UserService {
    
    static func searchGoogleBooksAPI(by userParameter: String, completion: @escaping (JSON) -> Void) {
        // Google books api
        let apiToContact = "https://www.googleapis.com/books/v1/volumes"
        
        // initial parameters
        let parameters: Parameters = ["q": userParameter, "printType": "books", "maxResults": "10", "key": Constants.APIKey.googleAPIKey]
        
        // Alamofire request
        Alamofire.request(apiToContact, parameters: parameters).responseJSON() { (response) in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    
                    completion(json)
                }
            case .failure(let error):
                
//                // request time out
//                if error._code == NSURLErrorTimedOut {
//                    //timeout here
//                }
                
                print(error)
                return
            }
        }
    }
    
    // create a new user
    static func createUser(fullName: String, email: String, password: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            // check for error
            if let error = error {
                assertionFailure(error.localizedDescription)
                return
            }
            
            // check user exists
            guard let user = user else { return }
            
            // create dictionary for user information
            let userAttr: [String: Any] = ["fullName": fullName, "email": email]
            
            // database reference
            let userRef = DatabaseReference.toLocation(.showUser(uid: user.uid))
            
            // add user's name and email to database
            userRef.updateChildValues(userAttr, withCompletionBlock: { (error, ref) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                    return
                }
            })
        }
    }
    
}// end struct

// MARK: - UIAlertController
extension UserService {
    // alert to tell user to only search by one parameter
    static func requestTimeout(view: UIViewController) {
        
        // alert and action
        let alert = UIAlertController(title: nil, message: "Request timed out. Please check internect connection and try again.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(okAction)
        
        view.present(alert, animated: true)
    }
}
