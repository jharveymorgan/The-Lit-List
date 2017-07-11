//
//  OnboardingViewController.swift
//  The Lit List
//
//  Created by Jordan Harvey-Morgan on 7/11/17.
//  Copyright © 2017 Jordan Harvey-Morgan. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    // MARK: - Properties

    @IBOutlet weak var collectionView: UICollectionView!
    
    let nib = UINib(nibName: "OnboardingCollectionViewCell", bundle: nil)
    
    // information for onboarding pages:
    let firstPage = "Welcome to The Lit List!"
    let secondPage = "Set reminders for the newest releases."
    let thirdPage = "Never miss a book or comic release again!"
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add nib to the collection view
        collectionView.register(nib, forCellWithReuseIdentifier: Constants.CollectionViewCell.onboarding)
        
        // configure collection view background
        collectionView.layer.backgroundColor = UIColor.clear.cgColor
    }
    
    // MARK: - IBActions
    @IBAction func signupButtonTapped(_ sender: Any) {
        print("pressed signup button")
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        print("pressed login button")
    }
    

}

// MARK: - UICollectionViewDataSource
extension OnboardingViewController: UICollectionViewDataSource {
    // to display onboarding pages
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CollectionViewCell.onboarding, for: indexPath) as! OnboardingCollectionViewCell
        
        cell.imageView.image = #imageLiteral(resourceName: "Onboarding Icon")
        cell.welcomeLabel.text = firstPage
        cell.setReminderLabel.text = secondPage
        cell.neverMissReminder.text = thirdPage
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
}

// MARK: - UICollectionViewDelegate
extension OnboardingViewController: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    // to get the correct sized cell(?)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
