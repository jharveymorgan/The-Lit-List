//
//  ResultsViewController.swift
//  The Lit List
//
//  Created by Jordan Harvey-Morgan on 6/29/17.
//  Copyright © 2017 Jordan Harvey-Morgan. All rights reserved.
//

import UIKit

// MARK: - Protocol
protocol ResultsViewControllerDelegate: class {
    func resultsViewControllerDidCancel(_ controller: ResultsViewController)
}

class ResultsViewController: UIViewController {
    // MARK: - Properties
    let xib = UINib(nibName: "LitListItemCell", bundle: nil)
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    weak var delegate: ResultsViewControllerDelegate?
    
    // MARK: - Subviews
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - VC Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // nib for the results list
        tableView.register(xib, forCellReuseIdentifier: Constants.TableViewCell.listItemCell)
        
        // configure background and nav bar
        cancelButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "SourceSansPro-Bold", size: 18)!], for: .normal)
        UIViewController.configureBackgroundColor(view: self.view)
        UINavigationController.configureNavBar(viewController: self)
    }
    
    // MARK: - Function(s)
    
    // MARK: - IBActions
    @IBAction func cancelButtonTapped(_ sender: Any) {
        delegate?.resultsViewControllerDidCancel(self)
    }
    
    // MARK: - Segue(s)
}

// MARK: - UITableViewDataSource
extension ResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCell.listItemCell, for: indexPath) as! LitLitItemCell
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ResultsViewController: UITableViewDelegate {
    
    // height for each cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
