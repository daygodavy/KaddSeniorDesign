//
//  InitialLoginViewController.swift
//  AgriGuardian
//
//  Created by Davy Chuon on 5/11/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseAuth
import CryptoKit
import AuthenticationServices

class InitialLoginViewController: UIViewController, GIDSignInDelegate, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding{
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var ref: DocumentReference? = nil
    let db = Firestore.firestore()
    let fbManager = FirebaseManager()
    fileprivate var currentNonce: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGoogleAuth()
    }
    
    
    // MARK: ACTIONS
    
    @IBAction func loginButtonPressed(_ sender: Any) {
    }
    
    @IBAction func appleLoginButtonPressed(_ sender: Any) {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @IBAction func googleLoginButtonPressed(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        
    }
    
    // MARK: FUNCTIONS
    
    func setupGoogleAuth() {
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
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
                    
                    
                    // check if user exists
                    self.fbManager.checkUser { check in
                        // if user doesn't exist, create in db
                        if check == false{
                            self.fbManager.createUser(email: email, uid: uid)
                            self.navigateToNewAcct()
                        }
                        self.navigateToHome()
                    }
                    
                }
                // START ACTIVITY INDICATOR HERE
                
                //This is where you should add the functionality of successful login
                //i.e. dismissing this view or push the home view controller etc
            }
        }
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    
    func navigateToHome() {
        // TODO:
        let thisStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let MainTabBarVC = thisStoryboard.instantiateViewController(withIdentifier: "MainTabBarController") as? MainTabBarController
        
        self.view.window?.rootViewController = MainTabBarVC
        self.view.window?.makeKeyAndVisible()
    }
    
    
    func navigateToNewAcct() {
        let thisStoryboard = UIStoryboard(name: "Onboarding", bundle: nil)
        let newAcctVC = thisStoryboard.instantiateViewController(withIdentifier: "IntroAccountInfoViewController") as? IntroAccountInfoViewController
        
        self.view.window?.rootViewController = newAcctVC
        self.view.window?.makeKeyAndVisible()
    }
    
    // MARK: DELEGATE
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            // Save authorised user ID for future reference
            UserDefaults.standard.set(appleIDCredential.user, forKey: "appleAuthorizedUserIdKey")
            
            // Retrieve the secure nonce generated during Apple sign in
            guard let nonce = self.currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }

            // Retrieve Apple identity token
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Failed to fetch identity token")
                return
            }

            // Convert Apple identity token to string
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Failed to decode identity token")
                return
            }

            // Initialize a Firebase credential using secure nonce and Apple identity token
            let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com",
                                                              idToken: idTokenString,
                                                              rawNonce: nonce)
                
            // Sign in with Firebase
            Auth.auth().signIn(with: firebaseCredential) { (authResult, error) in
                
                if let error = error {
                    print("0================")
                    print(error.localizedDescription)
                    return
                }
                print("1================")
                // Mak a request to set user's display name on Firebase
                let changeRequest = authResult?.user.createProfileChangeRequest()
                changeRequest?.displayName = appleIDCredential.fullName?.givenName
                changeRequest?.commitChanges(completion: { (error) in

                    if let error = error {
                        print(error.localizedDescription)
                        print("2================")
                    } else {
                        print("Updated display name: \(Auth.auth().currentUser?.displayName)")
                        print("3================")
                    }
                    print("4================")
                })
                if let uid = Auth.auth().currentUser?.uid, let email = Auth.auth().currentUser?.email {
                    
                    
                    // check if user exists
                    self.fbManager.checkUser { check in
                        // if user doesn't exist, create in db
                        if check == false{
                            self.fbManager.createUser(email: email, uid: uid)
                            self.navigateToNewAcct()
                        }
                        self.navigateToHome()
                    }
                    
                }
            }
            print("5================")
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


extension String  {
    var isNumber: Bool {
        print("CHECKING NUMBER")
        let check = !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        print(check)
        return check
    }
    var isnumberordouble: Bool { return Double(self.trimmingCharacters(in: .whitespaces)) != nil }
}

extension UITextField{
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }

    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}
