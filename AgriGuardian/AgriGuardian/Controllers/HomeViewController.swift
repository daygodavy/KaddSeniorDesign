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
    
    @IBOutlet weak var signOutButton: UIBarButtonItem!
    var currDevice = Device()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavBar()
        self.signOutButton.title = "SignOut"
        print("GOTEM: \(currDevice.name)")
        
    }
    
    @IBAction func SignOutButtonPressed(_ sender: Any) {
        print("attempting to signout")
        self.userLogout()
        self.goToHome()
    }
    
    private func setupNavBar() {
        self.navigationItem.title = "Home"
        self.signOutButton.title = "Sign Out"
    }
    
    func userLogout() {
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
    
    
    // ====TEMPORARY====: segue programatically (no unwind segue?)
    func goToHome() {
        
                let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        
                self.view.window?.rootViewController = loginViewController
                self.view.window?.makeKeyAndVisible()
        //
//        let mainStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let loginVC = mainStoryboard.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
//        let loginViewController = UINavigationController(rootViewController: loginVC)
//        self.present(loginViewController, animated: true)
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
