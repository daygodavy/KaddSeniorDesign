//
//  SettingsViewController.swift
//  AgriGuardian
//
//  Created by Daniel Weatrowski on 3/4/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class SettingsViewController: UITableViewController {
    var currDevice: Device = Device()
    var user: User = User()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        setupNavBar()
    }

    private func setupNavBar() {
        self.navigationItem.title = "Settings"
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.largeTitleDisplayMode  = .never
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
    private func segueToAboutView() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "AboutView") as! AboutViewController
        vc.title = "About"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func userLogout() {
        // Check provider ID to verify that the user has signed in with Apple
        if let providerId = Auth.auth().currentUser?.providerData.first?.providerID,
            providerId == "apple.com" {
            // Clear saved user ID
            UserDefaults.standard.set(nil, forKey: "appleAuthorizedUserIdKey")
        } else {
            GIDSignIn.sharedInstance().signOut()
        }
        
        // Perform sign out from Firebase
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        
        self.goToHome()
    }
    
    func goToHome() {
        let onboardStoryboard = UIStoryboard(name: "Onboarding", bundle: nil)
        
        let loginViewController = onboardStoryboard.instantiateViewController(withIdentifier: "InitialLoginViewController") as? InitialLoginViewController

        self.view.window?.rootViewController = loginViewController
        self.view.window?.makeKeyAndVisible()

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
            else if (indexPath.row == 2) {
                // TODO: Present an alert for User to select which device they seek to pull data from
                segueToDataPull()
            }
        case 1:
            // About
            if (indexPath.row == 1) {
            // About row - segue to about view
                segueToAboutView()
            }
        case 3:
            // Logout
            userLogout()
        default:
            break
        }
    }



}

class AboutViewController: UIViewController {
    // MARK: Properties
    @IBOutlet weak var buildLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        imageView.layer.cornerRadius = 20.0
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.systemGray.cgColor
        
        buildLabel.text = getVersion()
        
    }
    
    private func getVersion() -> String {
        let dict = Bundle.main.infoDictionary!
        let version = dict["CFBundleShortVersionString"] as! String
        let build = dict["CFBundleVersion"] as! String
        return "v\(version).\(build)"

    }
    
}

