//
//  ProfileSelectViewController.swift
//  AgriGuardian
//
//  Created by Davy Chuon on 2/27/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import Foundation
import UIKit

class ProfileSelectViewController: UIViewController {
    @IBOutlet weak var profilesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profilesCollectionView.delegate = self
        self.profilesCollectionView.dataSource = self
        
    }
}

extension ProfileSelectViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->
        UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionViewCell", for: indexPath) as! ProfileCollectionViewCell
            cell.bgView.backgroundColor = #colorLiteral(red: 1, green: 0.1118306135, blue: 0, alpha: 1)
            cell.profileNameLabel.text = "ATV #"
            
            //        cell.myLabel.text = "ABCD"
            return cell
    }
    


    
}
