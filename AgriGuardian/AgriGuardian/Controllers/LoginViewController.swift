//
//  LoginViewController.swift
//  AgriGuardian
//
//  Created by Davy Chuon on 2/19/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//
import UIKit
import Firebase
import GoogleSignIn
import FirebaseAuth

class LoginViewController: UIViewController, GIDSignInDelegate {
    var ref: DocumentReference? = nil
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        self.setupGoogleSignIn()
        
        // Do any additional setup after loading the view.
    }
    
    /**
     * Button Actions:
     */
    @IBAction func googleSignInPressed(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    /**
     * Functions:
     */
    func setupGoogleSignIn() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        // Automatically sign in the user.
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        guard let auth = user.authentication else { return }
        let credentials = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
        Auth.auth().signIn(with: credentials) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                print("Login Successful")
                print("UID: \(Auth.auth().currentUser?.uid)")
                if let uid = Auth.auth().currentUser?.uid, let email = Auth.auth().currentUser?.email {
                    self.createUser(uid: uid, email: email)
                    self.navigateToHome()
                }
                // START ACTIVITY INDICATOR HERE
                
                //This is where you should add the functionality of successful login
                //i.e. dismissing this view or push the home view controller etc
            }
        }
    }
    
    func createUser(uid: String, email: String) {
        // first check if uid already exists before creating user in db
        
        // create user in db
        ref = db.collection("users").document(uid)
        ref?.setData([
            "Email" : email,
            "Devices" : []
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(self.ref!.documentID)")
            }
        }
        
    }
    
    
    
    func navigateToHome() {
        // TODO:
        let ProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfilesViewController") as? ProfilesViewController
        
        self.view.window?.rootViewController = ProfileVC
        self.view.window?.makeKeyAndVisible()
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
