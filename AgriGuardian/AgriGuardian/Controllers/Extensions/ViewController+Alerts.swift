//
//  ViewController+Alerts.swift
//  AgriGuardian
//
//  Created by Daniel Weatrowski on 2/26/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func presentCustomAlert(title: String, message: String, completion: @escaping () -> Void) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            completion()
        }
        let image = UIImage(named: "bookmark")
        okAction.setValue(image, forKey: "image")
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentBasicAlert(title: String, message: String, completion: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            completion()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentWillDeleteAlert(title: String, message: String, actionTitle: String, completion: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: actionTitle, style: .destructive) { action in
            completion()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Are you sure?
    // Any changes made will not be saved
    // Cancel or Okay
}
