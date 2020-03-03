//
//  RideMapViewController.swift
//  AgriGuardian
//
//  Created by Daniel Weatrowski on 3/2/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit
import MapKit

class RideMapViewController: UIViewController {
    
    // MARK: - Properties
    var mapView: MKMapView = MKMapView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView = MKMapView(frame: self.view.frame)
        self.view.addSubview(mapView)

        // Do any additional setup after loading the view.
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
