//
//  LitLitItemCell.swift
//  The Lit List
//
//  Created by Jordan Harvey-Morgan on 6/28/17.
//  Copyright © 2017 Jordan Harvey-Morgan. All rights reserved.
//

import UIKit

class LitLitItemCell: UITableViewCell {
    // MARK: - Properties
    @IBOutlet weak var viewForBorder: UIView!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // make entire cell clear
        self.layer.backgroundColor = UIColor.clear.cgColor
        
        // for cell border
        viewForBorder.layer.backgroundColor = UIColor.clear.cgColor
        viewForBorder.layer.borderWidth = 2
        viewForBorder.layer.borderColor = UIColor.black.cgColor
    }

}
