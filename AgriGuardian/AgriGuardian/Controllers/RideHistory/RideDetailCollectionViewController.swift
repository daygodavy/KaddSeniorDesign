//
//  RideDetailCollectionViewController.swift
//  AgriGuardian
//
//  Created by Daniel Weatrowski on 3/1/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit
import MapKit
import ScrollableGraphView

class RideDetailCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var thisRide = Ride()
    var locationPoints = [CLLocation]()
    
    // MARK: - Properties
    fileprivate let cellID = "InfoCell"
    fileprivate let tempID = "cellID"
    fileprivate let headerID = "HeaderCell"
    fileprivate let mapID = "MapCell"
    fileprivate let graphID = "GraphCell"
    fileprivate let spacing: CGFloat = 8
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode  = .never
        registerCellClasses()
        registerFlowLayout()
        
        locationPoints = thisRide.locations
        // Do any additional setup after loading the view.
    }
    
    // MARK: Private Functions
    fileprivate func registerFlowLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.collectionView.collectionViewLayout = layout
    }
    
    fileprivate func registerCellClasses() {
        // register plain temp cell
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: tempID)
        let graphNib = UINib(nibName: "RideGraphCVCell", bundle: nil)
        self.collectionView.register(graphNib, forCellWithReuseIdentifier: graphID)
        // regiser main detail cell
        let cellNib = UINib(nibName: "RideDetailInfoCVC", bundle: nil)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: cellID)
        
        // register map cell
        let mapCellNib = UINib(nibName: "RideDetailMapCVC", bundle: nil)
        self.collectionView.register(mapCellNib, forCellWithReuseIdentifier: mapID)
        
        // regisert main header
        let headerNib = UINib(nibName: "RideDetailHeaderCRV", bundle: nil)
        self.collectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerID)
    }
    fileprivate func setupDetailCell(cell: RideDetailInfoCVC, indexPath: IndexPath) -> UICollectionViewCell  {
        switch(indexPath.row) {
        case 0:
            cell.titleLabel.text = "Total Time"
            cell.valueLabel.text = thisRide.getTime() 
            cell.iconLabel.image = UIImage(systemName: "clock")
        case 1:
            cell.titleLabel.text = "Avg. Speed"
            cell.valueLabel.text = thisRide.getAvgSpeed() + "mph"
            cell.iconLabel.image = UIImage(systemName: "speedometer")

        case 2:
            cell.titleLabel.text = "Miles"
            cell.valueLabel.text = thisRide.getMileage() + "mi"
            cell.iconLabel.image = UIImage(systemName: "circle")

        case 3:
            cell.titleLabel.text = "Rollovers"
            cell.valueLabel.text = "00"
            cell.iconLabel.image = UIImage(systemName: "exclamationmark.triangle.fill")

        case 4:
            cell.titleLabel.text = "Top Speed"
            cell.valueLabel.text = thisRide.getTopSpeed() + "mph"
            cell.iconLabel.image = UIImage(systemName: "gauge.badge.plus")
        case 5:
            cell.titleLabel.text = "Stops"
            cell.valueLabel.text = "0"
            cell.iconLabel.image = UIImage(systemName: "hexagon.fill")

        default:
            return UICollectionViewCell()
        }
        cell.bgView.backgroundColor = .systemGray6
        return cell
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 8

    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // dequeue main detail cells for 0th section
        if indexPath.row < 6 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! RideDetailInfoCVC
            //cell.titleLabel.text = "row: \(indexPath.row)"
            
            return setupDetailCell(cell: cell, indexPath: indexPath)
        }
        // deque special cells for 1st section
        else if indexPath.row == 6 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: graphID, for: indexPath) as! RideGraphCVCell
                cell.backgroundColor = .systemGray6
                cell.points = locationPoints
                
                return cell
        } else {
                let mapCell = collectionView.dequeueReusableCell(withReuseIdentifier: mapID, for: indexPath) as! RideDetailMapCVC
                mapCell.mapDelegate = self
                
                return mapCell
        }
    
//        } else {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tempID, for: indexPath)
//            cell.backgroundColor = .systemGray6
//            return cell
//        }

    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // dequeue header
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerID, for: indexPath) as! RideDetailHeaderCRV
//        header.locationLabel.text = thisRide.getRideCity()
        thisRide.getRideCity { thisCity in
            header.locationLabel.text = "📍 \(thisCity)"
        }
        
        return header
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow: CGFloat = 2
        let spacingBetweenCells: CGFloat = 8
        
        let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) // amount of total spacing in a row
        let widthWithSpacing = (view.frame.width - totalSpacing)/numberOfItemsPerRow
        let sizeWithSpacing = CGSize(width: widthWithSpacing, height: widthWithSpacing / 2)
        
        switch(indexPath.row) {
        case 0:
            return sizeWithSpacing
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
            return  .init(width: view.frame.width - 2 * spacingBetweenCells, height: 180)
        case 7:
            return .init(width: view.frame.width - 2 * spacingBetweenCells, height: 180)
            
//            if let collection = self.collectionView {
//                let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
//                return CGSize(width: width, height: width / 2)
//            } else {
//                return CGSize(width: 0, height: 0)
//            }

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
extension RideDetailCollectionViewController: MapCellDelegate {
    func didTapMap(_ sender: Any) {
        print("Map Pressed")
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "RideMapView")
        vc.title = "Map View"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
