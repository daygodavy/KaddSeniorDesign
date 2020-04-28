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
        setupView()

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

        } else {
            enableTextfields()
            self.navigationItem.rightBarButtonItem?.title = "Save"
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
