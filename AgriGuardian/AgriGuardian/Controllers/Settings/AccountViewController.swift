//
//  AccountViewController.swift
//  AgriGuardian
//
//  Created by Daniel Weatrowski on 4/21/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit
import Firebase

class AccountViewController: UITableViewController {
    
    // TODO: All logic in this controller should be developed under isEditing flag in order to enable editing
    // TODO: Use UIAlert from ViewController+Alerts.swift for changing password
    
    // MARK: - Properties
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    
    var user: User = User()
    let fbManager = FirebaseManager()
    let loadSignal: UIActivityIndicatorView = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.loadSignal.startAnimating()
        self.setupView()
        self.loadAcctInfo {
            self.loadSignal.stopAnimating()
        }

    }
    fileprivate func disableTextfields() {
        isEditing = false
        firstNameTF.isEnabled = false
        lastNameTF.isEnabled = false
        emailTF.isEnabled = false
        phoneTF.isEnabled = false
        tableView.reloadData()

    }
    fileprivate func enableTextfields() {
        isEditing = true
        firstNameTF.isEnabled = true
        lastNameTF.isEnabled = true
        emailTF.isEnabled = true
        phoneTF.isEnabled = true
        phoneTF.keyboardType = .numberPad
        tableView.reloadData()

    }
    
    fileprivate func setupView() {
        let button = UIBarButtonItem(title: "Edit", style: .plain, target: self, action:  #selector(didTapEdit))
        self.navigationItem.rightBarButtonItem = button
        disableTextfields()
    }
    @objc fileprivate func didTapEdit() {
        if (isEditing) {
            disableTextfields()
            self.navigationItem.rightBarButtonItem?.title = "Edit"
            
            // save fields to firebase
            self.saveAcctInfo()

        } else {
            enableTextfields()
            self.navigationItem.rightBarButtonItem?.title = "Save"
        }

    }
    
    func loadAcctInfo(completion: @escaping () -> Void) {
        fbManager.getUser(uid: user.uid) { curruser in
            print("GOT IT")
            print(curruser.uid)
            self.user = curruser
            self.firstNameTF.text = self.user.firstName
            self.lastNameTF.text = self.user.lastName
            self.phoneTF.text = self.user.phoneNumber
            self.emailTF.text = self.user.emailAddress
            self.tableView.reloadData()
        }
    }
    
    func saveAcctInfo() {
//        if let fn = firstNameTF.text, ln = lastNameTF.text, email = emailTF.text, pn = phoneTF.text {
//
//        }
        // save to fire base
        if let fn = firstNameTF.text, let ln = lastNameTF.text, let pn = phoneTF.text {
            fbManager.setAccountInfo(firstName: fn, lastName: ln, phoneNum: pn)
        }
        
        // store locally
        // ...
        self.loadAcctInfo {
            self.tableView.reloadData()
        }
    }
    
    
    // removes red editing icon
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    // hide action section when editing
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (isEditing) {
            if (indexPath.section == 1) {
                return 0
            }
            return 43.5
        } else {
            return 43.5
        }
        
    }


}
