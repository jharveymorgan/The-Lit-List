//
//  ResultsViewController.swift
//  The Lit List
//
//  Created by Jordan Harvey-Morgan on 6/29/17.
//  Copyright © 2017 Jordan Harvey-Morgan. All rights reserved.
//

import UIKit
import Kingfisher
import CoreData

// MARK: - Protocol
protocol ResultsViewControllerDelegate: class {
    func resultsViewControllerDidCancel(_ controller: ResultsViewController)
}

class ResultsViewController: UIViewController {
    // MARK: - Properties
    weak var delegate: ResultsViewControllerDelegate?
    var searchParameter = ""
    var bookResults = [BookToDisplay]()
    
    let xib = UINib(nibName: "LitListItemCell", bundle: nil)
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    // MARK: - Subviews
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - VC Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // nib for the results list
        tableView.register(xib, forCellReuseIdentifier: Constants.TableViewCell.listItemCell)
        
        // configure background and nav bar
        cancelButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "SourceSansPro-Bold", size: 18)!], for: .normal)
        UIViewController.configureBackgroundGradient(view: self.view)      
        
        // results of search
        getBookResults()
        
        // start activity indicator
        configureActivityIndicator()
        activityIndicator.startAnimating()
        
    }
    
    // MARK: - Function(s)
    func getBookResults() {
        UserService.searchGoogleBookssearchiTunesAPI(by: searchParameter) { (response) in
            let bookTotal = response["items"].count
            
            for count in 0..<bookTotal {
                let book = BookToDisplay(json: response["items"][count])
                self.bookResults.append(book)
            }
            
            // display results
            self.tableView.reloadData()
            
            // stop activity indicator after books are loaded
            self.activityIndicator.stopAnimating()
        }
    }
    
    // configure activity indicator
    func configureActivityIndicator() {
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.view.addSubview(activityIndicator)
    }
    
    // MARK: - IBActions
    @IBAction func cancelButtonTapped(_ sender: Any) {
        delegate?.resultsViewControllerDidCancel(self)
    }
    
    // MARK: - Segue(s)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.showResultDetail {
            let detailController = segue.destination as! ResultDetailViewController
            
            // get path and book for row that was tapped
            let indexPath = tableView.indexPathForSelectedRow
            detailController.bookToDisplay = bookResults[(indexPath?.row)!]
        }
    }
}

// MARK: - UITableViewDataSource
extension ResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCell.listItemCell, for: indexPath) as! LitLitItemCell
        
        // get information to display from the array of Books
        let book = bookResults[indexPath.row]
        
        // display results
        cell.titleLabel.text = book.title
        
        // handle multiple authors, if necessary
        cell.authorLabel.text = book.author
        
        // display cover image
        let coverURL = URL(string: book.imageLink)
        cell.coverImage.kf.setImage(with: coverURL)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ResultsViewController: UITableViewDelegate {
    
    // height for each cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    // show detail about selected book
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.Segue.showResultDetail, sender: self)
    }
}
