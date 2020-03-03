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
    var ref: DocumentReference? = nil
    let db = Firestore.firestore()
    var currUID: String = ""
    var profiles: [Device] = []
    var selectedIdx: Int = 0
    
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
                print("COUNT: \(deviceDocs.count)")
                for devices in deviceDocs {
                    let dev = Device(data: devices.data())
                    self.profiles.append(dev)
                    print("GRABBED DEVICE")
                    self.profilesCollectionView.reloadData()
                }
                print("RELOAD TABLE")
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
            "manufacturer:" : device.manufacturer,
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
            //            cell.profileNameLabel.text = "ATV #"
            
            //        cell.myLabel.text = "ABCD"
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigateToHome(idx: indexPath.section)
        self.selectedIdx = indexPath.item
    }
    
}

