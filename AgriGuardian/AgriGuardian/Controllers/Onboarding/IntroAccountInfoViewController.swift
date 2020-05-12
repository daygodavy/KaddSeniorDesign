//
//  IntroAccountInfoViewController.swift
//  AgriGuardian
//
//  Created by Davy Chuon on 5/11/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit

class IntroAccountInfoViewController: UIViewController {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    var fbManager: FirebaseManager = FirebaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.phoneNumberTextField.keyboardType = .phonePad
        self.firstNameTextField.addDoneButtonOnKeyboard()
        self.lastNameTextField.addDoneButtonOnKeyboard()
        self.phoneNumberTextField.addDoneButtonOnKeyboard()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func beginButtonPressed(_ sender: Any) {
        if let firstN = firstNameTextField.text, !firstN.isEmpty, let lastN = lastNameTextField.text, !lastN.isEmpty, let phoneN = phoneNumberTextField.text, !phoneN.isEmpty, phoneN.count == 10 {
            fbManager.setupNewUser(firstName: firstN, lastName: lastN, phoneNum: phoneN)
            self.navigateToHome()
        }
    }
    
    
    func navigateToHome() {
        // TODO:
        let thisStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let MainTabBarVC = thisStoryboard.instantiateViewController(withIdentifier: "MainTabBarController") as? MainTabBarController
        
        self.view.window?.rootViewController = MainTabBarVC
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

//extension UITextField {
//    @IBInspectable var doneAccessory: Bool {
//        get{
//            return self.doneAccessory
//        }
//        set (hasDone) {
//            if hasDone{
//                addDoneButtonOnKeyboard()
//            }
//        }
//    }
//
//    func addDoneButtonOnKeyboard()
//    {
//        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
//        doneToolbar.barStyle = .default
//
//        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
//
//        let items = [flexSpace, done]
//        doneToolbar.items = items
//        doneToolbar.sizeToFit()
//
//        self.inputAccessoryView = doneToolbar
//    }
//
//    @objc func doneButtonAction()
//    {
//        self.resignFirstResponder()
//    }
//}
