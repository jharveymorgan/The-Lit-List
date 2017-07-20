//
//  ReminderHelper.swift
//  The Lit List
//
//  Created by Jordan Harvey-Morgan on 6/30/17.
//  Copyright © 2017 Jordan Harvey-Morgan. All rights reserved.
//

//import Foundation
import UIKit
import EventKit

struct ReminderHelper {
    
    // check if user authorized access to their Reminders app
    static func checkReminderAuthorizationStatus(view: UIViewController, bookTitle: String,reminder: EKReminder, eventStore: EKEventStore) {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.reminder)
        
        switch (status) {
        case EKAuthorizationStatus.authorized:
            // Things are in line with being able to show the calendars in the table view
            
            reminder.calendar = eventStore.defaultCalendarForNewReminders()
            saveReminder(reminder: reminder, eventStore: eventStore, view: view, bookTitle: bookTitle)
        
        case EKAuthorizationStatus.notDetermined:
            // This happens on first-run
            
            // save the reminder if the user is approving reminders for the first time
            requestAccessToReminders(eventStore: eventStore) { (access) in
                if access == true {
                    reminder.calendar = eventStore.defaultCalendarForNewReminders()
                    saveReminder(reminder: reminder, eventStore: eventStore, view: view, bookTitle: bookTitle)
                } else {
                    accessDeniedAlert(viewController: view)
                }
            }
        
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            // We need to help them give us permission
            accessDeniedAlert(viewController: view)
        }
    }
    
    // ask for access to user's Reminders
    static func requestAccessToReminders(eventStore: EKEventStore, completion: @escaping (Bool) -> Void) {
        eventStore.requestAccess(to: .reminder, completion: { (accessGranted: Bool, error: Error?) in
            if accessGranted == true {
                print("access to Reminders is granted")
                completion(true)
            } else {
                print("access to Reminders WASN'T granted. Error: \(String(describing: error))")
                completion(false)
            }
        })
    }
    
    // if access is denied, alert user that access is needed in order to set reminders
    static func accessDeniedAlert(viewController: UIViewController) {
        let message = "The Lit List needs access to Reminders in order to remind you about newly released titles! Please change the permissions in Settings."
        let deniedAlert = UIAlertController(title: "Access Denied", message: message, preferredStyle: .actionSheet)
        
        // cancel
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        deniedAlert.addAction(cancel)
        
        // go to settings
        let goToSettings = UIAlertAction(title: "Go To Settings", style: .default, handler: { action in
            // open user's settings app
            let openSettingsUrl = URL(string: UIApplicationOpenSettingsURLString)
            UIApplication.shared.open(openSettingsUrl!, options: [:], completionHandler: nil)
        })
        deniedAlert.addAction(goToSettings)
        
        // present the alert
        viewController.present(deniedAlert, animated: true)
    }
    
    // if adding the reminder was successful
    static func reminderWasSaved(viewController: UIViewController, bookTitle: String) {
        
        let message = "You got it. We added a reminder for when \(bookTitle) comes out."
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        // thanks
        let thanks = UIAlertAction(title: "Thanks!", style: .default, handler: nil)
        alert.addAction(thanks)
        
        // configure alert text
        alert.setValue(NSAttributedString(string: message, attributes: [NSFontAttributeName: UIFont(name: "SourceSansPro-Bold", size: 18)!]), forKey: "attributedMessage")
        
        viewController.present(alert, animated: true)
    }
    
    // add a reminder
    static func saveReminder(reminder: EKReminder, eventStore: EKEventStore, view: UIViewController, bookTitle: String) {
        do {
            try eventStore.save(reminder, commit: true)
            reminderWasSaved(viewController: view, bookTitle: bookTitle)
        } catch {
            print("Error creating and saving new reminder: \(error)")
        }
    }
    
    // get correct date for reminder
    static func dateComponentFromNSDate(date: NSDate)-> NSDateComponents{
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour], from: date as Date)
        
        return dateComponents as NSDateComponents
    }
}
