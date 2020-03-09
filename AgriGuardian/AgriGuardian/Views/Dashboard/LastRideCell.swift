//
//  LastRideCell.swift
//  AgriGuardian
//
//  Created by Daniel Weatrowski on 3/8/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit
import MapKit
class LastRideCell: UICollectionViewCell {
    // MARK: - Properties
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let layer = CAGradientLayer()
        layer.startPoint = CGPoint(x: 0.5, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.frame = contentView.frame
        layer.colors = [UIColor.systemGray6.cgColor, UIColor.clear.cgColor]
        mapView.layer.addSublayer(layer)
    }

}
