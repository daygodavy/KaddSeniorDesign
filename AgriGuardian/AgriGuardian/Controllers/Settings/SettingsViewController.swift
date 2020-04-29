//
//  SettingsViewController.swift
//  AgriGuardian
//
//  Created by Daniel Weatrowski on 3/4/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    var currDevice: Device = Device()
    var user: User = User()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        setupNavBar()
      

        // Do any additional setup after loading the view.
    }
    
//    fileprivate func buildForm() {
//        form +++ Section("General")
//              <<< TextRow() { row in
//                  row.title = "Account"
//              }
//            <<< TextRow() { row in
//                row.title = "Farm Info"
//            }
//             <<< TextRow() { row in
//                 row.title = "Members"
//             }
//             <<< SwitchRow() { row in
//                  row.title = "Automatic (iOS)"
//              }
//            <<< SwitchRow() { row in
//                row.title = "Dark Mode"
//            }
//            <<< SwitchRow() { row in
//                row.title = "iCloud Sync"
//            }
//
//            +++ Section("Security")
//                <<< SwitchRow() { row in
//                    row.title = "Use Face ID"
//                }
//                  <<< TextRow() { row in
//                      row.title = "Data Usage"
//                  }
//                <<< TextRow() { row in
//                    row.title = "Research Purpose"
//                }
//                <<< TextRow() { row in
//                    row.title = "Privacy Policy"
//                }
//
//            form +++ Section("About")
//                <<< TextRow() { row in
//                    row.title = "Info"
//                }
//                <<< EmailRow() { row in
//                     row.title = "Feedback"
//                    row.value = "info@kadd.com"
//                 }
//                <<< URLRow() { row in
//                     row.title = "Website"
//                     row.value = URL(string: "https://kadd.io")
//                 }
//                <<< TextRow() { row in
//                     row.title = "Rate Agriguardian"
//                 }
//
//
//    }
    private func setupNavBar() {
        self.navigationItem.title = "Settings"
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.largeTitleDisplayMode  = .never
//        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
//        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
//        self.navigationItem.rightBarButtonItem = doneButton
//        self.navigationItem.leftBarButtonItem = cancelButton
    }
    private func segueToAccountView() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "AccountView") as! AccountViewController
        vc.title = "Account Info"
        vc.user = self.user // DO I NEED THIS
        navigationController?.pushViewController(vc, animated: true)
    }
    private func segueToDevicesView() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "ManageDevicesView")
        vc.title = "Your Devices"
        navigationController?.pushViewController(vc, animated: true)
    }
    private func segueToDataPull() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(identifier: "DataPullView") as! DataPullViewController
        vc.title = "Data Pull"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section) {
        case 0:
            // General
            if (indexPath.row == 0) {
            // Account row - segue to account view
                segueToAccountView()
            }
            else if (indexPath.row == 1) {
                // Manage Devices view
                segueToDevicesView()
            }
            else if (indexPath.row == 3) {
                // TODO: Present an alert for User to select which device they seek to pull data from
                segueToDataPull()
            }
        default:
            break
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

