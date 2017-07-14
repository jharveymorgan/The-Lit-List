//
//  CoreDataHelper.swift
//  The Lit List
//
//  Created by Jordan Harvey-Morgan on 6/30/17.
//  Copyright © 2017 Jordan Harvey-Morgan. All rights reserved.
//

import CoreData
import UIKit
import SwiftyJSON

class CoreDataHelper {
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let persistentContainer = appDelegate.persistentContainer
    static let managedContext = persistentContainer.viewContext
    
    // create a new book
    static func newBook(json: JSON) -> Book {
        let book = NSEntityDescription.insertNewObject(forEntityName: "Book", into: managedContext) as! Book
        
        // check for multiple authors
        let authorsTotal = json["volumeInfo"]["authors"].count
        let authors = json["volumeInfo"]["authors"]
        
        book.author = ""
        if authorsTotal > 1 {
            for count in 0..<authorsTotal {
                if count == (authorsTotal - 1) {
                    (book.author)!.append(authors[count].stringValue)
                } else {
                    (book.author)!.append(authors[count].stringValue + ", ")
                }
            }
        } else {
            book.author = json["volumeInfo"]["authors"][0].stringValue
        }
        
        // other info
        book.title = json["volumeInfo"]["title"].stringValue
        book.releaseDate = json["volumeInfo"]["publishedDate"].stringValue
        book.price = json["saleInfo"]["retailPrice"]["amount"].stringValue
        book.imageLink = json["volumeInfo"]["imageLinks"]["thumbnail"].stringValue
        book.isbn = json["volumeInfo"]["industryIdentifiers"][0]["identifier"].stringValue
        book.bookDescription = json["volumeInfo"]["description"].stringValue
        book.googleBooksLink = json["volumeInfo"]["canonicalVolumeLink"].stringValue
        
        // correct date
        var correctDate: Date? {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            guard let date = dateFormatter.date(from: book.releaseDate!) else {
                book.releaseDate = "No Release Date Available"
                return nil
            }
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
            let finalDate = calendar.date(from:components)
            
            return finalDate!
        }
        
        if let dateToDisplay = correctDate as NSDate? {
            book.correctDate = dateToDisplay
        }
        
        return book
    }
    
    // save a book
    static func saveBook() {
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error)")
        }
    }
    
    // delete
    static func delete(book: Book) {
        managedContext.delete(book)
        saveBook()
    }
    
    // get book
    static func retrieveBooks() -> [Book] {
        let fetchRequest = NSFetchRequest<Book>(entityName: "Book")
        do {
            let results = try managedContext.fetch(fetchRequest)
            return results
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return []
    }
    
    
}

