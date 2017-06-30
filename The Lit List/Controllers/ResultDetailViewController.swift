//
//  ResultDetailViewController.swift
//  The Lit List
//
//  Created by Jordan Harvey-Morgan on 6/29/17.
//  Copyright © 2017 Jordan Harvey-Morgan. All rights reserved.
//

import UIKit

class ResultDetailViewController: UIViewController {
    // MARK: - Properties
    var book = Book()
    
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
        
        // configure view
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.descriptionView.layer.backgroundColor = UIColor.clear.cgColor
        UIViewController.configureBackgroundGradient(view: self.view)
        UINavigationController.configureNavBar(viewController: self)
        
        // display book information
        configureBookDetail(book: book)

    }
    
    // MARK: - Functions
    // display information
    func configureBookDetail(book: Book) {
        // format date
        if let releaseDate = book.correctDate {
            releaseDateLabel.text = timestampFormatter.string(from: releaseDate)
        } else {
            releaseDateLabel.text = "No Release Date Found"
        }
        
        titleLabel.text = book.title
        authorLabel.text = book.author
        descriptionView.text = book.description
        let coverURL = URL(string: book.imageLink)
        coverImage.kf.setImage(with: coverURL)
    }
    
    
    // MARK: IBActions
    

}
