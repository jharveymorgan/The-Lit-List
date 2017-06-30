//
//  YourLitListViewController.swift
//  The Lit List
//
//  Created by Jordan Harvey-Morgan on 6/28/17.
//  Copyright © 2017 Jordan Harvey-Morgan. All rights reserved.
//

import UIKit
import CoreData

class YourLitListViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    
    var myLitList = [Book]()
    
    let xib = UINib(nibName: "LitListItemCell", bundle: nil)
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // nib for the main list
        tableView.register(xib, forCellReuseIdentifier: Constants.TableViewCell.listItemCell)
        
        // configure main view
        UIViewController.configureBackgroundGradient(view: self.view)
        UINavigationController.configureNavBar(viewController: self)
    }
    
    // display current list of books
    override func viewDidAppear(_ animated: Bool) {
        myLitList = CoreDataHelper.retrieveBooks()
        tableView.reloadData()
    }
    
    // MARK: - Function(s)
    
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
        if let coverLink = book.imageLink {
            let coverURL = URL(string: coverLink)
            cell.coverImage.kf.setImage(with: coverURL)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CoreDataHelper.delete(book: myLitList[indexPath.row])
            myLitList = CoreDataHelper.retrieveBooks()
            
            print(myLitList.count)
            
            tableView.reloadData()
            print("delete")
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
