//
//  BookService.swift
//  The Lit List
//
//  Created by Jordan Harvey-Morgan on 7/19/17.
//  Copyright © 2017 Jordan Harvey-Morgan. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct BookService {
    
    static let timestampFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        return dateFormatter
    }()
    
    // get all of the current user's saved books
    static func allBooks(for user: User, completion: @escaping ([BookToDisplay]) -> Void) {
        let ref = DatabaseReference.toLocation(.books(uid: user.uid))
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }
            
            // REVIEW
            // Should I be using a dispatch group(?)
            let books: [BookToDisplay] = snapshot.flatMap {
                guard let book = BookToDisplay(snapshot: $0) else { return nil }
                
                return book
            }
            
            completion(books)
        })
    }
    
    // leta  user create a new book
    static func create(book: BookToDisplay) {
        let currentUser = User.current
        
        // information to add to Firebase Database
        let bookInfo: [String: Any] = ["title": book.title, "author": book.author, "bookDescription": book.description, "imageLink": book.imageLink, "googleBooksLink": book.googleBooksLink, "isbn": book.isbn, "releaseDate": book.releaseDate, "price": book.price]
        
        // reference for where to add to Firebase Database
        let newBookRef = DatabaseReference.toLocation(.newBook(currentUID: currentUser.uid))
        
        // add books to firebase
        newBookRef.updateChildValues(bookInfo)
    }
    
    // create add a book from CoreData to Firebase
    static func createFromCoreData(book: Book) {
        let currentUser = User.current
        
        // check book information exists
        guard let title = book.title, let author = book.author, let bookDescription = book.bookDescription, let imageLink = book.imageLink, let googleBooksLink = book.googleBooksLink, let isbn = book.isbn, let price = book.price, let releaseDate = book.releaseDate
            else { return }
        
        // information to add to Firebase Database
        let bookInfo: [String: Any] = ["title": title, "author": author, "bookDescription": bookDescription, "imageLink": imageLink, "googleBooksLink": googleBooksLink, "isbn": isbn, "releaseDate": releaseDate, "price": price]
        
        // reference for where to add to Firebase Database
        let newBookRef = DatabaseReference.toLocation(.newBook(currentUID: currentUser.uid))
        
        // add books to firebase
        newBookRef.updateChildValues(bookInfo)
    }
    
    // delete a book from firebase
    static func delete(book: BookToDisplay) {
        let currentUser = User.current
        let bookInfo = ["books/\(currentUser.uid)/\(book.key)": NSNull()]
        
        let ref = Database.database().reference()
        ref.updateChildValues(bookInfo) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
        }
        
        
    }
    
}
