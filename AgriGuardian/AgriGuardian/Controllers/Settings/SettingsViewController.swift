//
//  SettingsViewController.swift
//  AgriGuardian
//
//  Created by Daniel Weatrowski on 3/4/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit
import Eureka

class SettingsViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        buildForm()

        // Do any additional setup after loading the view.
    }
    
    fileprivate func buildForm() {
        form +++ Section("General")
              <<< TextRow() { row in
                  row.title = "Account"
              }
            <<< TextRow() { row in
                row.title = "Farm Info"
            }
             <<< TextRow() { row in
                 row.title = "Members"
             }
             <<< SwitchRow() { row in
                  row.title = "Automatic (iOS)"
              }
            <<< SwitchRow() { row in
                row.title = "Dark Mode"
            }
            <<< SwitchRow() { row in
                row.title = "iCloud Sync"
            }

            +++ Section("Security")
                <<< SwitchRow() { row in
                    row.title = "Use Face ID"
                }
                  <<< TextRow() { row in
                      row.title = "Data Usage"
                  }
                <<< TextRow() { row in
                    row.title = "Research Purpose"
                }
                <<< TextRow() { row in
                    row.title = "Privacy Policy"
                }

            form +++ Section("About")
                <<< TextRow() { row in
                    row.title = "Info"
                }
                <<< EmailRow() { row in
                     row.title = "Feedback"
                    row.value = "info@kadd.com"
                 }
                <<< URLRow() { row in
                     row.title = "Website"
                     row.value = URL(string: "https://kadd.io")
                 }
                <<< TextRow() { row in
                     row.title = "Rate Agriguardian"
                 }
                
 
    }
    private func setupNavBar() {
        self.navigationItem.title = "Settings"
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
//        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
//        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
//        self.navigationItem.rightBarButtonItem = doneButton
//        self.navigationItem.leftBarButtonItem = cancelButton
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
