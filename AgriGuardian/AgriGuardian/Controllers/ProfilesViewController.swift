//
//  ProfilesViewController.swift
//  AgriGuardian
//
//  Created by Davy Chuon on 3/1/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit
import Firebase

class ProfilesViewController: UIViewController {
    
    
    @IBOutlet weak var profilesCollectionView: UICollectionView!
    @IBOutlet weak var editButton: UIButton!
    var ref: DocumentReference? = nil
    let db = Firestore.firestore()
    var currUID: String = ""
    var profiles: [Device] = []
    var selectedIdx: Int = 0
    var editMode: Bool = false
    var deletedProfiles: [Int] = []
    var isSelected: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profilesCollectionView.delegate = self
        self.profilesCollectionView.dataSource = self
        
        // load device profiles from firebase
        self.loadProfiles()
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
                self.createDeviceProfile(name: name)
            }
            
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        print(editButton.currentTitle)
        if let status = editButton.currentTitle{
            if status == "Edit" {
                
                self.editButton.setTitle("Done", for: .normal)
//                self.editButton.titleLabel?.text = "Done"
                self.editMode = true
            }
            else {
                print("STATUS IS NOT EDIT")
                // check to confirm deletion with Alert? --> is good then delete
                //            self.deleteCells()
                self.editButton.setTitle("Edit", for: .normal)
//                self.editButton.titleLabel?.text = "Edit"
                self.editMode = false
            }
        }
    }
    
    
    
    func loadProfiles() {
        if let id = Auth.auth().currentUser?.uid {
            self.currUID = id
        }
        let root = Firestore.firestore().collection("devices").whereField("uid", isEqualTo: self.currUID)
        print(currUID)
        root.getDocuments() {data, error in
            if let err = error {
                print("\(err)")
            }
            if let deviceDocs = data?.documents {
                for devices in deviceDocs {
                    let dev = Device(data: devices.data())
                    self.profiles.append(dev)
                    
                    self.isSelected.append(true)
                    
                    self.profilesCollectionView.reloadData()
                }
                self.profilesCollectionView.reloadData()
            }
        }
    }
    
    func createDeviceProfile(name: String) {
        let newVehicle = Device.init()
        newVehicle.name = name
        profiles.append(newVehicle)
        profilesCollectionView.reloadData()
        
        self.addToDevice(device: newVehicle)
    }
    
    func addToDevice(device: Device) {
        let ref = Firestore.firestore().collection("devices").document()
        ref.setData([
            "name" : device.name,
            "modelNumber" : device.modelNumber,
            "serialNumber" : device.serialNumber,
            "atvModel" : device.atvModel,
            "manufacturer" : device.manufacturer,
            "hardwareVersion" : device.hardwareVersion,
            "firmwareVersion" : device.firmwareVersion,
            "uid" : currUID
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref.documentID)")
                self.addToUserDevice(id: ref.documentID)
                
            }
        }
        
    }
    
    func addToUserDevice(id: String) {
        if let uid = Auth.auth().currentUser?.uid {
            let ref = db.collection("users").document(uid)
            ref.updateData([
                "Devices" : FieldValue.arrayUnion([id])
            ]) {err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Successfully updated users.device: \(ref.documentID)")
                }
            }
        }
    }
    
    
    func navigateToHome(idx: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let MainTabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
        MainTabBarController.chosenDevice = profiles[idx]
        MainTabBarController.modalPresentationStyle = .fullScreen
        self.present(MainTabBarController, animated: true, completion: nil)
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
            cell.selectedToggle.isHidden = isSelected[indexPath.section]
            //            cell.profileNameLabel.text = "ATV #"
            
            //        cell.myLabel.text = "ABCD"
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionViewCell", for: indexPath) as! ProfileCollectionViewCell
        print("=====HIDDEN======: \(cell.selectedToggle.isHidden)")
        if editMode == false {
            //            navigateToHome(idx: indexPath.section)
            //            self.selectedIdx = indexPath.item
        }
        else {
            // append label representing cell is selected for deletion
            
            if isSelected[indexPath.section] == true {
                isSelected[indexPath.section] = false
            } else {
                isSelected[indexPath.section] = true
            }
            profilesCollectionView.reloadData()
            
//            print("HIDDEN?: \(cell.selectedToggle.isHidden)")
//            if cell.selectedToggle.isHidden == true {
//                cell.selectedToggle.isHidden = false
////                print("false")
////                deletedProfiles.append(indexPath.section)
//            }
//            else {
//                cell.selectedToggle.isHidden = true
////                print("true")
////                deletedProfiles.remove(at: indexPath.section)
//            }
            
            
//            print("DELETEDPROFILES: \(deletedProfiles)")
            
        }
        
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionViewCell", for: indexPath) as! ProfileCollectionViewCell
//        if editMode == true {
//            // remove label represented cell is deselected for deletion
//            cell.selectedToggle.isHidden = true
//            deletedProfiles.remove(at: indexPath.section)
//            print("DESELECTEDPROFILES: \(deletedProfiles)")
//        }
//    }
    
}

