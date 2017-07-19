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

typealias FIRUser = FirebaseAuth.User

struct UserService {
    
    static func searchGoogleBooksAPI(by userParameter: String, viewController: UIViewController, completion: @escaping (JSON) -> Void) {
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
                self.requestError(viewController: viewController)
                print(error)
                return
            }
        }
    }
    
    // create a new user
    static func createUser(fullName: String, email: String, password: String, completion: @escaping (User?, NSError?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (user: FIRUser?, error) in
            // check for error
            if let error = error as NSError? {
                
                if error.code == AuthErrorCode.invalidEmail.rawValue {
                    print("Invalid Email! Error Code: \(error.code)")
                    return completion(nil, error)
                }

                //assertionFailure(error.localizedDescription)
                return completion(nil, error)
            }
            
            // create dictionary for user information
            let userAttr: [String: Any] = ["fullName": fullName, "email": email]
            
            // check user exists and get path to their data
            guard let user = user else { return }
            let userRef = DatabaseReference.toLocation(.showUser(uid: user.uid))
            
            // add user's name and email to database
            userRef.updateChildValues(userAttr, withCompletionBlock: { (error, ref) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                    return
                }
                
                // handle newly created user, ie: read data that was just written 
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    let user = User(snapshot: snapshot)
                    completion(user, nil)
                })
            })
        }
    }
    
    // login an existing user
    static func loginUser(email: String, password: String, completion: @escaping (User?, NSError?) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (user: FIRUser?, error) in
            
            // handle errors and check for invalid email or password
            if let error = error as NSError? {
                
                if error.code == AuthErrorCode.wrongPassword.rawValue {
                    print("Wrong Password!")
                    return completion(nil, error)
                } else if error.code == AuthErrorCode.invalidEmail.rawValue {
                    print("Invalid Email!")
                    return completion(nil, error)
                } else if error.code == AuthErrorCode.userNotFound.rawValue {
                    print("User does not exist")
                    return completion(nil, error)
                }
                
                assertionFailure(error.localizedDescription)
                return //completion(error)
            }
            
            // if the user gets logged in, get their information
            // check user exists and get path to the data
            guard let user = user else { return }
            let userRef = DatabaseReference.toLocation(.showUser(uid: user.uid))
            
            // read data for user that was just logged in
            userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                completion(user, nil)
            })
        }
    }
    
    // reset a user's password
    static func sendResetLink(email: String, completion: @escaping (NSError?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            
            if let error = error as NSError? {
              
                if error.code == AuthErrorCode.invalidEmail.rawValue {
                    print("Invalid Email")
                    return completion(error)
                } else if error.code == AuthErrorCode.userNotFound.rawValue {
                    print("User doesn't exist")
                    return completion(error)
                }
                
                assertionFailure(error.localizedDescription)
                return
            }
            
            // reset link was sent
            completion(nil)
        }
    }
}// end struct

// MARK: - UIAlertController
extension UserService {
    // alert to tell user to only search by one parameter
    static func requestError(viewController: UIViewController) {
        
        // alert and action
        let alert = UIAlertController(title: nil, message: "Error. Please check internect connection and try again.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(okAction)
        
        viewController.present(alert, animated: true)
    }
}
