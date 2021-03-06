//
//  ResultDetailViewController.swift
//  The Lit List
//
//  Created by Jordan Harvey-Morgan on 6/29/17.
//  Copyright © 2017 Jordan Harvey-Morgan. All rights reserved.
//

import UIKit
import SwiftyJSON

class ResultDetailViewController: UIViewController {
    // MARK: - Properties
    var bookDetail = BookToDisplay()
    var bookToSaveJSON = JSON("")
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var descriptionView: UITextView!
    
    let timestampFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        return dateFormatter
    }()
    
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure navigation bar and view's background
        self.navigationController?.navigationBar.tintColor = UIColor.black
        UINavigationController.configureNavBar(viewController: self)
        UIViewController.configureBackgroundAliceBlue(view: self.view)
        
        // configure the description view so its clear and starts at the top
        self.descriptionView.contentInset = UIEdgeInsetsMake(-2,-5,0,0)
        self.descriptionView.layer.backgroundColor = UIColor.clear.cgColor
        
        // display book information
        configureBookDetail(book: bookDetail)
        
        bookToSaveJSON = bookDetail.json

    }
    // make sure nav bar doesn't stay clear after view is dismissed
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
    }
    
    // MARK: - Functions
    // display information
    func configureBookDetail(book: BookToDisplay) {
        // format date
        if let releaseDate = book.correctDateFromJSON {
            releaseDateLabel.text = timestampFormatter.string(from: releaseDate)
        } else {
            releaseDateLabel.text = book.releaseDate
        }
        
        titleLabel.text = book.title
        authorLabel.text = book.author
        descriptionView.text = book.description
        
        // cover image
        let coverURL = URL(string: book.imageLink)
        coverImage.kf.setImage(with: coverURL)
    }
    
    
    // MARK: - IBActions
    // TODO: Dismiss view after button is tapped
    @IBAction func addToListTapped(_ sender: Any) {
        // create a new book in firebase
        BookService.create(book: bookDetail)
        
        // tell user the book was added to their lit list
        bookAddedToLitList(book: bookDetail)
    }
    
    // MARK: - Segue(s)
}

// MARK: - AlertController
extension ResultDetailViewController {
    // alert to tell user to only search by one parameter
    func bookAddedToLitList(book: BookToDisplay) {
        let messageText = "\(book.title) has been added to your Lit List."
        
        // alert and action
        let alert = UIAlertController(title: nil, message: messageText, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(okAction)
        
        // configure alert text
//        alert.setValue(NSAttributedString(string: messageText, attributes: [NSFontAttributeName: UIFont(name: "SourceSansPro-Bold", size: 18)!]), forKey: "attributedMessage")
        
        self.present(alert, animated: true)
    }
    
}
