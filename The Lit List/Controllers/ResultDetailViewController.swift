//
//  ResultDetailViewController.swift
//  The Lit List
//
//  Created by Jordan Harvey-Morgan on 6/29/17.
//  Copyright © 2017 Jordan Harvey-Morgan. All rights reserved.
//

import UIKit
import CoreData

class ResultDetailViewController: UIViewController {
    // MARK: - Properties
    var book = NSEntityDescription.insertNewObject(forEntityName: "Book", into: CoreDataHelper.managedContext) as! Book
    
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
        UIViewController.configureBackgroundGradient(view: self.view)
        
        // configure the description view so its clear and starts at the top
        self.descriptionView.contentInset = UIEdgeInsetsMake(-2,-5,0,0)
        self.descriptionView.layer.backgroundColor = UIColor.clear.cgColor
        
        // display book information
        configureBookDetail(book: book)

    }
    // make sure nav bar doesn't stay clear after view is dismissed
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
    }
    
    // MARK: - Functions
    // display information
    func configureBookDetail(book: Book) {
        // format date
        if let releaseDate = book.correctDate {
            releaseDateLabel.text = timestampFormatter.string(from: releaseDate as Date)
        } else {
            releaseDateLabel.text = "No Release Date Found"
        }
        
        titleLabel.text = book.title
        authorLabel.text = book.author
        descriptionView.text = book.bookDescription
        
        // cover image
        if let coverLink = book.imageLink {
            let coverURL = URL(string: coverLink)
            coverImage.kf.setImage(with: coverURL)
        }
    }
    
    
    // MARK: IBActions
    @IBAction func addToListTapped(_ sender: Any) {
        print("add to list tapped")
    }
    
    // MARK: - Segue(s)
}
