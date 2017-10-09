//
//  YourLitListViewController.swift
//  The Lit List
//
//  Created by Jordan Harvey-Morgan on 6/28/17.
//  Copyright © 2017 Jordan Harvey-Morgan. All rights reserved.
//

import UIKit
import SystemConfiguration

class YourLitListViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    
    var myLitList = [BookToDisplay]()
    var filteredBooks = [BookToDisplay]()
    let refreshControl = UIRefreshControl()
    let searchController = UISearchController(searchResultsController: nil)
    //let searchController = UISearchController(searchResultsController: ItemDetailViewController)
    
    let xib = UINib(nibName: "LitListItemCell", bundle: nil)
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // nib for the main list
        tableView.register(xib, forCellReuseIdentifier: Constants.TableViewCell.listItemCell)
        
        // configure main view
        UIViewController.configureBackgroundAliceBlue(view: self.view)
        
        // add pull to refresh
        refreshControl.addTarget(self, action: #selector(reloadLitList), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        // configure search bar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true // search bar doesn't stay on screen if user leaves main view
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.sizeToFit()
        
        // add search bar to the table view
        tableView.tableHeaderView = searchController.searchBar
    }
    
    // display current list of books
    override func viewDidAppear(_ animated: Bool) {
        // check if books should be uploaded to firebase
        if CoreDataHelper.retrieveBooks().count > 0 {
            let books = CoreDataHelper.retrieveBooks()
            fromCoreDataToFirebase(books: books)
        }
        
        // check for internet
        let internet = isInternetAvailable()
        if !internet {
            noInternetAlert()
        }
        
        // get all books from firebase
        BookService.allBooks(for: User.current) { (books) in
            self.myLitList = books
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Function(s)
    func fromCoreDataToFirebase(books: [Book]) {
        for book in books {
            BookService.createFromCoreData(book: book)
            CoreDataHelper.delete(book: book)
        }
    }
    
    @objc func reloadLitList() {
        // get books from Firebase
        BookService.allBooks(for: User.current) { (books) in
            self.myLitList = books
            
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.showItemDetail {
            // show detail
            let navController = segue.destination as! UINavigationController
            let mainDetailViewController = navController.topViewController as! ItemDetailViewController
            
            // show detail of correct book depending on whether user was searching or not
            if isFiltering() {
                mainDetailViewController.book = filteredBooks[(tableView.indexPathForSelectedRow?.row)!]
            } else {
                mainDetailViewController.book = myLitList[(tableView.indexPathForSelectedRow?.row)!]
            }
        }
    }
}// end classs

// MARK: - UITableViewDataSource
extension YourLitListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // check if user is searching, if so, return the number of search results
        if isFiltering() {
            return filteredBooks.count
        }
        
        return myLitList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCell.listItemCell, for: indexPath) as! LitLitItemCell
        
        // get information to display depending on whether or not the user is searching
        let book: BookToDisplay
        if isFiltering() {
            book = filteredBooks[indexPath.row]
        } else {
            book = myLitList[indexPath.row]
        }
        
        // display results
        cell.titleLabel.text = book.title
        
        // handle multiple authors, if necessary
        cell.authorLabel.text = book.author
        
        // display cover image
        let coverURL = URL(string: book.imageLink)
        cell.coverImage.kf.setImage(with: coverURL)
        
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

// MARK: - Search Bar
//Allow class to know as the text is changing
extension YourLitListViewController: UISearchResultsUpdating {
    // UISearchResultsUpdating delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    func searchBarEmpty() -> Bool {
        // returns true if the the search bar is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    // filter myLitList based on the search text
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredBooks = myLitList.filter {
            $0.title.lowercased().contains(searchText.lowercased())
        }
        
        // reload the view
        tableView.reloadData()
    }
    
    // function to check if currently filtering results
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarEmpty()
    }
}

// MARK: - Check for internet
extension YourLitListViewController {
    // check if internet is available
    func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    // let user know they need an internet connection
    func noInternetAlert() {
        let alert = UIAlertController(title: nil, message: "Error. Please check internect connection and try again.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(okAction)
        
        self.present(alert, animated: true)
    }
}
