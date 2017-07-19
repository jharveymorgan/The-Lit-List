//
//  bookToDisplay.swift
//  The Lit List
//
//  Created by Jordan Harvey-Morgan on 6/30/17.
//  Copyright © 2017 Jordan Harvey-Morgan. All rights reserved.
//

import Foundation
import SwiftyJSON
import FirebaseDatabase.FIRDataSnapshot

class BookToDisplay {
    var title: String
    var author: String
    var releaseDate: String
    var price: String
    var imageLink: String
    var isbn: String
    var description: String
    var googleBooksLink: String
    var key: String
    var json: JSON
    
    // convert the date to the correct format from CoreData
    var correctDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yy"
        
        guard let date = dateFormatter.date(from: releaseDate) else {
            self.releaseDate = "No Release Date Available"
            return nil
        }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
        let finalDate = calendar.date(from:components)
        
        return finalDate!
    }
    
    var correctDateFromJSON: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dateFormatter.date(from: releaseDate) else {
            self.releaseDate = "No Release Date Available"
            return nil
        }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
        let finalDate = calendar.date(from:components)
        
        return finalDate!
    }
    
    
    // TODO: failable initializer?
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let title = dict["title"] as? String,
            let author = dict["author"] as? String,
            let releaseDate = dict["releaseDate"] as? String,
            let bookDescription = dict["bookDescription"] as? String,
            let isbn = dict["isbn"] as? String,
            let imageLink = dict["imageLink"] as? String,
            let googleBooksLink = dict["googleBooksLink"] as? String,
            let price = dict["price"] as? String
            else { return nil }
        
        self.title = title
        self.author = author
        self.releaseDate = releaseDate
        self.price = price
        self.imageLink = imageLink
        self.isbn = isbn
        self.description = bookDescription
        self.googleBooksLink = googleBooksLink
        
        self.key = snapshot.key
        
        self.json = JSON("")
    }
    
    
    init(json: JSON) {
        
        // check for multiple authors
        let authorsTotal = json["volumeInfo"]["authors"].count
        let authors = json["volumeInfo"]["authors"]
        
        self.author = ""
        if authorsTotal > 1 {
            for count in 0..<authorsTotal {
                if count == (authorsTotal - 1) {
                    self.author.append(authors[count].stringValue)
                } else {
                    self.author.append(authors[count].stringValue + ", ")
                }
            }
        } else {
            self.author = json["volumeInfo"]["authors"][0].stringValue
        }
        
        
        self.title = json["volumeInfo"]["title"].stringValue
        self.releaseDate = json["volumeInfo"]["publishedDate"].stringValue
        self.price = json["saleInfo"]["retailPrice"]["amount"].stringValue
        self.imageLink = json["volumeInfo"]["imageLinks"]["thumbnail"].stringValue
        self.isbn = json["volumeInfo"]["industryIdentifiers"][0]["identifier"].stringValue
        self.description = json["volumeInfo"]["description"].stringValue
        self.googleBooksLink = json["volumeInfo"]["canonicalVolumeLink"].stringValue
        
        self.key = ""
        
        self.json = json
    }
    
    init() {
        self.title = ""
        self.author = ""
        self.releaseDate = ""
        self.price = ""
        self.imageLink = ""
        self.isbn = ""
        self.description = ""
        self.googleBooksLink = ""
        self.key = ""
        self.json = JSON("")
    }

}
