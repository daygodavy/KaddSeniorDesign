//
//  CrashReportViewController.swift
//  AgriGuardian
//
//  Created by Daniel Weatrowski on 5/26/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit
import MapKit

class CrashReportViewController: UITableViewController {
    
    // MARK: - Properties
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var vehicleModelLabel: UILabel!
    @IBOutlet weak var firstRespondersLabel: UILabel!
    
    var crashLocation: CLLocationCoordinate2D?
    
    // MARK: - Actions
    @IBAction func didTapOpen(_ sender: Any) {
        let latitude: CLLocationDegrees = 37.2
        let longitude: CLLocationDegrees = 22.9

        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Place Name"
        mapItem.openInMaps(launchOptions: options)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }


}
