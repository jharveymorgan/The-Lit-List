//
//  OnboardingCollectionViewCell.swift
//  The Lit List
//
//  Created by Jordan Harvey-Morgan on 7/11/17.
//  Copyright © 2017 Jordan Harvey-Morgan. All rights reserved.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var setReminderLabel: UILabel!
    @IBOutlet weak var neverMissReminder: UILabel!
    
    
    @IBOutlet weak var labelStack: UIStackView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // configure background and label
        self.layer.backgroundColor = UIColor.clear.cgColor
    }

}
