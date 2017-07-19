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
        
        case books(uid: String)
        case newBook(currentUID: String)
        
        case showUser(uid: String)
        case showSpecificBook(uid: String, bookKey: String)
        
        // convert the case into a Database Reference
        func asDatabaseReference() -> DatabaseReference {
            let root = Database.database().reference()
            
            
            switch self {
            case .root:
                return root
            case .books(let uid):
                return root.child("books").child(uid)
            case .newBook(let currentUID):
                return root.child("books").child(currentUID).childByAutoId()
            case .showUser(let uid):
                return root.child("users").child(uid)
            case .showSpecificBook(let uid, let bookKey):
                return root.child("books").child(uid).child(bookKey)
            }
        }
    }
    
    // static func to get location
    static func toLocation(_ location: LitListLocation) -> DatabaseReference {
        return location.asDatabaseReference()
    }
    
}
