//
//  HomeViewController.swift
//  AgriGuardian
//
//  Created by Davy Chuon on 2/29/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit
import GoogleSignIn
import FirebaseAuth

class HomeViewController: UIViewController {
    
    var currDevice = Device()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavBar()
    }
    
    
    @objc func SignOutButtonPressed(_ sender: Any) {
        print("attempting to signout")
        self.userLogout()
        self.goToHome()
    }
    
    // MARK: - Private functions
    private func setupNavBar() {
        self.navigationItem.title = "Dashboard"
        let devicesButton = UIBarButtonItem(image: UIImage(systemName: "antenna.radiowaves.left.and.right"), style: .plain, target: self, action: #selector(showDevices))
        //self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.leftBarButtonItem = devicesButton
    }
    

    
    fileprivate func userLogout() {
        GIDSignIn.sharedInstance().signOut()
        //        GIDSignIn.sharedInstance().
        //        let firebaseAuth = Auth.auth()
        //        do {
        //            print("DO")
        //          try firebaseAuth.signOut()
        //        } catch let signOutError as NSError {
        //          print ("Error signing out: %@", signOutError)
        //        }
    }
    @objc fileprivate func showDevices() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(identifier: "DeviceMenu") as! DevicesCollectionViewController
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true, completion: nil)
    }
    
    
    
    // ====TEMPORARY====: segue programatically (no unwind segue?)
    fileprivate func goToHome() {
        
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController

        self.view.window?.rootViewController = loginViewController
        self.view.window?.makeKeyAndVisible()

    }
}
