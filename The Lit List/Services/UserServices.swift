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

struct UserService {
    
    static func searchGoogleBookssearchiTunesAPI(by userParameter: String, completion: @escaping (JSON) -> Void) {
        // Google books api
        let apiToContact = "https://www.googleapis.com/books/v1/volumes"
        
        // initial parameters
        let parameters: Parameters = ["q": userParameter, "printType": "books", "maxResults": "10", "key": HideAPIKey.apiKey]
        
        // Alamofire request
        Alamofire.request(apiToContact, parameters: parameters).responseJSON() { (response) in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    
                    completion(json)
                }
            case .failure(let error):
                print(error)
                return
            }
        }
    }
    
}
