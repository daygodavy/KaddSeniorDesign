//
//  ProfilesViewController.swift
//  AgriGuardian
//
//  Created by Davy Chuon on 3/1/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit

class ProfilesViewController: UIViewController {
    
    @IBOutlet weak var profilesCollectionView: UICollectionView!
    var profiles: [Device] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profilesCollectionView.delegate = self
        self.profilesCollectionView.dataSource = self
        
        // load device profiles from firebase
        
    }
    
    @IBAction func addVehicleButtonPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "Add New Vehicle", message: "", preferredStyle: .alert)
        
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Vehicle Name"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil )
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            print("textfield: \(firstTextField.text)")
            if let name = firstTextField.text, !name.isEmpty {
                self.createProfile(name: name)
            }
            
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func createProfile(name: String) {
        let newVehicle = Device.init()
        newVehicle.name = name
        profiles.append(newVehicle)
        profilesCollectionView.reloadData()
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

extension ProfilesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.profiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->
        UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionViewCell", for: indexPath) as! ProfileCollectionViewCell
            cell.bgView.backgroundColor = #colorLiteral(red: 1, green: 0.1118306135, blue: 0, alpha: 1)
            cell.vehicleNameLabel.text = "\(profiles[indexPath.section].name)"
            //            cell.profileNameLabel.text = "ATV #"
            
            //        cell.myLabel.text = "ABCD"
            return cell
    }
    
    
    
    
}

