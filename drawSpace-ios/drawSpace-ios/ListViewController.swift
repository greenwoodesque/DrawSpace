//
//  ListViewController.swift
//  drawSpace-ios
//
//  Created by David Greenwood on 7/29/20.
//  Copyright © 2020 David Greenwood. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let composeButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(launchDrawPad))
            title = "Drawings!"
            navigationItem.rightBarButtonItem = composeButton
    }

    @objc func launchDrawPad() {
        navigationController?.pushViewController(DrawPadViewController(), animated: true)
    }
}


