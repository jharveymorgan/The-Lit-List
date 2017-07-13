//
//  DatabaseReference+Location.swift
//  The Lit List
//
//  Created by Jordan Harvey-Morgan on 7/13/17.
//  Copyright © 2017 Jordan Harvey-Morgan. All rights reserved.
//

import Foundation
import FirebaseDatabase

extension DatabaseReference {
    
    enum LitListLocation {
        // cases to read and write to Firebase Database
        case root
        case showUser(uid: String)
        
        // convert the case into a Database Reference
        func asDatabaseReference() -> DatabaseReference {
            let root = Database.database().reference()
            
            
            switch self {
            case .root:
                return root
            case .showUser(let uid):
                return root.child("users").child(uid)
            }
        }
    }
    
    // static func to get location
    static func toLocation(_ location: LitListLocation) -> DatabaseReference {
        return location.asDatabaseReference()
    }
    
}
