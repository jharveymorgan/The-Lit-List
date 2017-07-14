//
//  User.swift
//  The Lit List
//
//  Created by Jordan Harvey-Morgan on 7/14/17.
//  Copyright © 2017 Jordan Harvey-Morgan. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class User: NSObject {
    
    // MARK: - Properties
    let uid: String
    let fullName: String
    
    // MARK: - Init(s)
    init(uid: String, fullName: String) {
        self.uid = uid
        self.fullName = fullName
        
        super.init()
    }
    
    init? (snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: Any], let fullName = dict["fullName"] as? String else {
            return nil
        }
        
        self.uid = snapshot.key
        self.fullName = fullName
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let uid = aDecoder.decodeObject(forKey: Constants.UserDefaults.uid) as? String, let fullName = aDecoder.decodeObject(forKey: Constants.UserDefaults.fullName) as? String else { return nil }
        
        self.uid = uid
        self.fullName = fullName
        
        super.init()
    }
    
    // MARK: - Singleton
    private static var _current: User?
    
    // getter for the variable that holds the current user, which is private
    static var current: User {
        guard let currentUser = _current else { fatalError("Current user doesn't exist") }
        return currentUser
    }
    
    // MARK: - Class Methods
    // setter for private variable that holds the current user
    static func setCurrent(_ user: User, writeToUserDefaults: Bool = false) {
        if writeToUserDefaults {
            // turn User into data
            let data = NSKeyedArchiver.archivedData(withRootObject: user)
            // store the data for the current user under the correct path in UserDefaults 
            UserDefaults.standard.set(data, forKey: Constants.UserDefaults.currentUser)
        }
        
        _current = user
    }
    
}

// MARK: - NSCoding
extension User: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: Constants.UserDefaults.uid)
        aCoder.encode(fullName, forKey: Constants.UserDefaults.fullName)
    }
}
