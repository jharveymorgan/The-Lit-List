//
//  ItemDetailViewController.swift
//  The Lit List
//
//  Created by Jordan Harvey-Morgan on 6/29/17.
//  Copyright © 2017 Jordan Harvey-Morgan. All rights reserved.
//

import UIKit
import EventKit

class ItemDetailViewController: UIViewController {

    // MARK: - Properties
    var book = Book()
    var eventStore: EKEventStore!
    //var eventStore = EKEventStore()
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    @IBOutlet weak var remindMeButton: UIButton!
    @IBOutlet weak var buyBookButton: UIButton!
    @IBOutlet weak var googleBooksButton: UIButton!
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
        UIViewController.configureBackgroundHoki(view: self.view)
        UINavigationController.configureNavBar(viewController: self)
        
        // configure the description view so it hasea clear background clear and starts at the top
        self.descriptionView.contentInset = UIEdgeInsetsMake(-2,-5,0,0)
        self.descriptionView.layer.backgroundColor = UIColor.clear.cgColor
        
        // display book information
        configureBookDetail(book: book)
        
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
        descriptionView.text = book.bookDescription
        
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
        // check for a book title
        guard let bookTitle = book.title else {
            print("Error getting book's title when trying to set a reminder")
            return
        }
        
        // check for reminder date
        guard let reminderDateComponents = book.correctDate else {
            print("Error getting book's correct date when trying to set a reminder")
            noReleaseDate()
            return
        }
        
        // configure reminder
        self.eventStore = EKEventStore()
        let reminder = EKReminder(eventStore: self.eventStore)
        reminder.title = "\(bookTitle) was released today!"
        reminder.dueDateComponents = ReminderHelper.dateComponentFromNSDate(date: reminderDateComponents) as DateComponents
        reminder.calendar = self.eventStore.defaultCalendarForNewReminders()
        
        // check for access to Reminders
        ReminderHelper.checkReminderAuthorizationStatus(view: self, reminder: reminder, eventStore: self.eventStore)
        
    }

    // buy in iBooks Store
    @IBAction func buyBookButtonTapped(_ sender: Any) {
        
        // check for isbn
        guard let bookISBN = book.isbn else {
            print("Error getting book's isbn when trying to buy via iBooks")
            return
        }
        // open in iBooks Store
        let iBooksLink = createAffiliateLink(for: bookISBN)
        UIApplication.shared.open(URL(string: iBooksLink)!, options: [:], completionHandler: nil)
    }
    
    // Google Books info page
    @IBAction func googleBooksButtonTapped(_ sender: Any) {
        
        // check for google books link
        guard let googleBooksLink = book.googleBooksLink else {
            print("Error getting google book's link when trying to get information via Google Books")
            return
        }
        
        // open google books link
        UIApplication.shared.open(URL(string: googleBooksLink)!, options: [:], completionHandler: nil)
    }
    
}


extension ItemDetailViewController {
    func noReleaseDate() {
        let alert = UIAlertController(title: nil, message: "Unable to set a reminder because there is no release date available.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(okAction)
        
        self.present(alert, animated: true)
    }
}
