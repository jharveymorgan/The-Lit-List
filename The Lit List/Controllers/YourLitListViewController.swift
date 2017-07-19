//
//  YourLitListViewController.swift
//  The Lit List
//
//  Created by Jordan Harvey-Morgan on 6/28/17.
//  Copyright © 2017 Jordan Harvey-Morgan. All rights reserved.
//

import UIKit

class YourLitListViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    
    //var myLitList = [Book]()
    var myLitList = [BookToDisplay]()
    
    let xib = UINib(nibName: "LitListItemCell", bundle: nil)
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // nib for the main list
        tableView.register(xib, forCellReuseIdentifier: Constants.TableViewCell.listItemCell)
        
        // configure main view
        UIViewController.configureBackgroundAliceBlue(view: self.view)
    }
    
    // display current list of books
    override func viewDidAppear(_ animated: Bool) {
        //myLitList = CoreDataHelper.retrieveBooks()
        
        // check if books should be uploaded to firebase
        if CoreDataHelper.retrieveBooks().count > 0 {
            let books = CoreDataHelper.retrieveBooks()
            fromCoreDataToFirebase(books: books)
        }
        
        // get all books from firebase
        BookService.allBooks(for: User.current) { (books) in
            self.myLitList = books
            self.tableView.reloadData()
        }
        
        
        //tableView.reloadData()
    }
    
    // MARK: - Function(s)
    func fromCoreDataToFirebase(books: [Book]) {
        print("Books in CoreData")
        
        for book in books {
            BookService.createFromCoreData(book: book)
            CoreDataHelper.delete(book: book)
        }
        
        print("Done uploading to firebase")
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.showItemDetail {
            // show detail
            let navController = segue.destination as! UINavigationController
            let mainDetailViewController = navController.topViewController as! ItemDetailViewController
            
            mainDetailViewController.book = myLitList[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
}// end classs

// MARK: - UITableViewDataSource
extension YourLitListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myLitList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCell.listItemCell, for: indexPath) as! LitLitItemCell
        
        // get information to display from the array of Books
        let book = myLitList[indexPath.row]
        
        // display results
        cell.titleLabel.text = book.title
        
        // handle multiple authors, if necessary
        cell.authorLabel.text = book.author
        
        // display cover image
//        if let coverLink = book.imageLink {
            let coverURL = URL(string: book.imageLink)
            cell.coverImage.kf.setImage(with: coverURL)
//        }
        
        return cell
    }
    
    // swipe to delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // delete the book
            BookService.delete(book: myLitList[indexPath.row])
            
            // get all books from firebase
            BookService.allBooks(for: User.current) { (books) in
                self.myLitList = books
                self.tableView.reloadData()
            }
        }
    }
    
}

// MARK: - UITableViewDelegate
extension YourLitListViewController: UITableViewDelegate {
    
    // height for each cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    // show detail about selected book
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.Segue.showItemDetail, sender: self)
    }
}
