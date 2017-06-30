//
//  Constants.swift
//  The Lit List
//
//  Created by Jordan Harvey-Morgan on 6/28/17.
//  Copyright © 2017 Jordan Harvey-Morgan. All rights reserved.
//

import Foundation

struct Constants {
    // Segues
    struct Segue {
        static let showItemDetail = "showItemDetail"
        static let showResults = "showResults"
        static let showResultDetail = "showResultDetail"
    }
    
    // Cells
    struct TableViewCell {
        static let listItemCell = "listItemCell"
        static let litListContentCell = "litListContentCell"
    }
    
    // Errors
    enum SearchError: Error {
        case invalidSearchParameters
        case NoSearchParameters
    }
    
    // Affiliate LInk
    struct iTunesAffiliate {
        static let affiliateID = "1001lxxD"
    }
}
