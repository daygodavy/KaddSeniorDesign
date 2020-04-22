//
//  AccountViewController.swift
//  AgriGuardian
//
//  Created by Daniel Weatrowski on 4/21/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit

class AccountViewController: UITableViewController {
    
    // TODO: All logic in this controller should be developed under isEditing flag in order to enable editing
    // TODO: Use UIAlert from ViewController+Alerts.swift for changing password
    
    // MARK: - Properties
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

         self.navigationItem.rightBarButtonItem = self.editButtonItem
    }


}
