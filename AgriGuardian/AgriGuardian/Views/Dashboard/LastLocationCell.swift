//
//  LastLocationCell.swift
//  AgriGuardian
//
//  Created by Daniel Weatrowski on 3/8/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit
import MapKit

class LastLocationCell: UICollectionViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    var location: CLLocation?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.mapView.isScrollEnabled = false

    }
    
    func loadLastLocation(location: CLLocation?) {
        
        guard let thisLocation = location else {
            print("Last Location is nil")
            return
        }
        
        // load thisLocation coordinate on mapView
        let region = MKCoordinateRegion(center: thisLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008))
        DispatchQueue.main.async {
            let annotation = MKPointAnnotation()
            annotation.coordinate = thisLocation.coordinate
            self.mapView.addAnnotation(annotation)
            self.mapView.setRegion(region, animated: false)
        }
        
        
    }

}
