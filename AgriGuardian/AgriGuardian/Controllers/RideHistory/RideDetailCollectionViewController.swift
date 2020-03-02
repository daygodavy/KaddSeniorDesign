//
//  RideDetailCollectionViewController.swift
//  AgriGuardian
//
//  Created by Daniel Weatrowski on 3/1/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit
 

class RideDetailCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let cellID = "cellID"
    fileprivate let headerID = "headerID"
    fileprivate let spacing: CGFloat = 8
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.collectionView.backgroundColor = .separator
        self.navigationItem.largeTitleDisplayMode  = .never
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: headerID)
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.collectionView.collectionViewLayout = layout
        // Do any additional setup after loading the view.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        switch(section) {
        case 0:
            return 6
        case 1:
            return 2
        default:
            return 0
        }

    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        cell.backgroundColor = .systemGray6
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableCell(withReuseIdentifier: "headerID", for: indexPath)
        header.backgroundColor = .systemBackground
        return header
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch(section) {
        case 0:
            return .init(width: view.frame.width, height: 200)
        case 1:
            return .init(width: view.frame.width, height: 0)

        default:
            return .init(width: view.frame.width, height: 0)

        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow: CGFloat = 2
        let spacingBetweenCells: CGFloat = 8
        
        let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) // amount of total spacing in a row

        
        switch(indexPath.section) {
        case 0:
            if let collection = self.collectionView {
                let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
                return CGSize(width: width, height: width / 2)
            } else {
                return CGSize(width: 0, height: 0)
            }
        case 1:
            return .init(width: view.frame.width - 2 * spacingBetweenCells, height: 150)
        default:
            return CGSize(width: 0, height: 0)
        }
        
        
        

        
        

    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
