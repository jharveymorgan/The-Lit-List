//
//  ItemDetailViewController.swift
//  The Lit List
//
//  Created by Jordan Harvey-Morgan on 6/29/17.
//  Copyright © 2017 Jordan Harvey-Morgan. All rights reserved.
//

import UIKit

class ItemDetailViewController: UIViewController {

    // MARK: - Properties
    var book = Book()
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    @IBOutlet weak var remindMeButton: UIButton!
    @IBOutlet weak var buyBookButton: UIButton!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    let timestampFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        return dateFormatter
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure view
        doneButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "SourceSansPro-Bold", size: 19)!], for: .normal)
        UIViewController.configureBackgroundGradient(view: self.view)
        UINavigationController.configureNavBar(viewController: self)
        
        // configure the description view so it hasea clear background clear and starts at the top
        self.descriptionView.contentInset = UIEdgeInsetsMake(-2,-5,0,0)
        self.descriptionView.layer.backgroundColor = UIColor.clear.cgColor
        
        // display book information
        //configureBookDetail(book: book)
        
    }
    
    // MARK: - Function(s)
    // construct the affiliate link
    func createAffiliateLink(for bookISBN: String) -> String {
        let affiliateLink = "https://geo.itunes.apple.com/us/book/isbn\(bookISBN)?mt=11&at=\(Constants.iTunesAffiliate.affiliateID)"
        return affiliateLink
    }
    
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
        descriptionView.text = book.description
        
        // cover image
        if let coverLink = book.imageLink {
            let coverURL = URL(string: coverLink)
            coverImage.kf.setImage(with: coverURL)
        }
    }
    
    // MARK: - IBActions
    @IBAction func doneButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func remindMeButtonTapped(_ sender: Any) {
        print("remind me button tapped")
    }

    @IBAction func buyBookButtonTapped(_ sender: Any) {
        print("buy book button tapped")
    }
}
