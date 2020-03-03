//
//  RideDetailMapCVC.swift
//  AgriGuardian
//
//  Created by Daniel Weatrowski on 3/2/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit
import MapKit

protocol MapCellDelegate {
    func didTapMap(_ sender: Any)
}

class RideDetailMapCVC: UICollectionViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapButton: UIButton!
    var mapDelegate: MapCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func didSelectMap(_ sender: Any) {
        mapDelegate?.didTapMap(sender)
    }
    

}
