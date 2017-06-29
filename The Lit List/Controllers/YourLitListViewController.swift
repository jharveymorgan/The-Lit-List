//
//  YourLitListViewController.swift
//  The Lit List
//
//  Created by Jordan Harvey-Morgan on 6/28/17.
//  Copyright © 2017 Jordan Harvey-Morgan. All rights reserved.
//

import UIKit

class YourLitListViewController: UIViewController {
    // MARK: - Properties
    let xib = UINib(nibName: "LitListItemCell", bundle: nil)
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // nib for the main list
        tableView.register(xib, forCellReuseIdentifier: Constants.TableViewCell.listItemCell)
        
        // background color
        let backgroundLayer = ColorHelper.backgroundGradient()
        backgroundLayer.frame = view.frame
        view.layer.insertSublayer(backgroundLayer, at: 0)
        
        // clear navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
}

// MARK: - UITableViewDataSource
extension YourLitListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCell.listItemCell, for: indexPath) as! LitLitItemCell
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension YourLitListViewController: UITableViewDelegate {
    
    // height for each cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
