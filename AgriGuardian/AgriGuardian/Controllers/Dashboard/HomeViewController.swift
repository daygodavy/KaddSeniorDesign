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

class HomeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    private let reuseIdentifier = "Cell"
    var currDevice = Device()
    fileprivate let spacing: CGFloat = 16.0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavBar()
        registerFlowLayout()
        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseIdentifier)
    }
    
    
    @objc func SignOutButtonPressed(_ sender: Any) {
        print("attempting to signout")
        self.userLogout()
        self.goToHome()
    }
    
    // MARK: - Private functions    
    fileprivate func registerFlowLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.collectionView.collectionViewLayout = layout
    }
    
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
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 9
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) 
    
        cell.backgroundColor = .systemGray5
    
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // dequeue header
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseIdentifier, for: indexPath)
        let label = UILabel()
        label.text = "Device Name"
        header.addSubview(label)
        return header
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            return .init(width: view.frame.width, height: 50)
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow: CGFloat = 2
        let spacingBetweenCells: CGFloat = spacing
        
        let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells)
        let widthWithSpacing = (view.frame.width - totalSpacing)/numberOfItemsPerRow
        let sizeWithSpacing = CGSize(width: widthWithSpacing, height: widthWithSpacing)
        switch(indexPath.row) {
        case 0:
            return .init(width: view.frame.width - 2 * spacing, height: 150)
        case 1:
            return sizeWithSpacing
        case 2:
            return sizeWithSpacing
        case 3:
            return sizeWithSpacing
        case 4:
            return sizeWithSpacing
        case 5:
            return sizeWithSpacing
        case 6:
            return sizeWithSpacing
        case 7:
            return .init(width: view.frame.width - 2 * spacing, height: 200)
        case 8:
            return .init(width: view.frame.width - 2 * spacing, height: 200)
        default:
            return .init(width: view.frame.width - 2 * spacing, height: 80)
        }
    }
}
