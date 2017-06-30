//
//  Book.swift
//  The Lit List
//
//  Created by Jordan Harvey-Morgan on 6/29/17.
//  Copyright © 2017 Jordan Harvey-Morgan. All rights reserved.
//

import Foundation
import SwiftyJSON

class Book {
    var title: String
    var author: [String]
    var releaseDate: String
    var price: String
    var imageLink: String
    var isbn: String
    
    // convert the dateto the correct format
    var correctDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: releaseDate)!
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
        let finalDate = calendar.date(from:components)
        
        return finalDate!
    }
    
    
    init(json: JSON) {
        
        // check for multiple authors
        let bookAuthors = json["items"][0]["volumeInfo"]["authors"]
        self.author = [String]()
        if bookAuthors.count > 1 {
            for author in bookAuthors {
                self.author.append(String(describing: author))
            }
        } else {
            self.author = [json["items"][0]["volumeInfo"]["authors"][0].stringValue]
        }
        
        
        self.title = json["volumeInfo"]["title"].stringValue
        self.releaseDate = json["volumeInfo"]["publishedDate"].stringValue
        self.price = json["saleInfo"]["retailPrice"]["amount"].stringValue
        self.imageLink = json["volumeInfo"]["imageLinks"]["thumbnail"].stringValue
        self.isbn = json["volumeInfo"]["industryIdentifiers"][0]["identifier"].stringValue
     }
     
     /*init(title: String, author: String, releaseDate: String, price: String, link: String, id: Int) {
     self.title = title
     self.author = author
     self.releaseDate = releaseDate
     self.price = price
     self.link = link
     self.id = id
     } */
    
    init() {
        self.title = ""
        self.author = [""]
        self.releaseDate = ""
        self.price = ""
        self.imageLink = ""
        self.isbn = "0"
    }
}
