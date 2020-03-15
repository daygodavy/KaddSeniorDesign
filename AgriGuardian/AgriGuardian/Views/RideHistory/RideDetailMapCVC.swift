//
//  RideDetailMapCVC.swift
//  AgriGuardian
//
//  Created by Daniel Weatrowski on 3/2/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit
import MapKit
//import Firebase

protocol MapCellDelegate {
    func didTapMap(_ sender: Any)
}

class RideDetailMapCVC: UICollectionViewCell, MKMapViewDelegate{
    
    // MARK: - Properties
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapButton: UIButton!
    var mapDelegate: MapCellDelegate?
    var dataManager = DataManager()
    
    // TESTING
    var currUID: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let ride = dataManager.loadGPSData(csvFile: "gps_2020_03_09", ofType: "csv")
        let locations = ride.locations
        
        
        // TESTING
        mapView.delegate = self
        let initialLoc = CLLocation(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        self.centerMapOnLocation(location: initialLoc)
        
        
        self.loadRoute(coords: locations)
    }
    
    @IBAction func didSelectMap(_ sender: Any) {
        mapDelegate?.didTapMap(sender)
    }
    
    func loadRoute(coords: [CLLocation]) {
        var traceRoute: [CLLocation] = []
        for coord in coords {
            traceRoute.append(coord)
            if traceRoute.count == 2 {
                let prev = traceRoute[0].coordinate
                let curr = traceRoute[1].coordinate
                let area = [prev, curr]
                let polyline = MKPolyline(coordinates: area, count: area.count)
                mapView.addOverlay(polyline)
            }
            else {
                traceRoute.append(coord)
                let prev = traceRoute[0].coordinate
                let curr = traceRoute[1].coordinate
                let area = [prev, curr]
                let polyline = MKPolyline(coordinates: area, count: area.count)
                mapView.addOverlay(polyline)
            }
            traceRoute.removeFirst()
        }
    }
    
    
    
    
    func centerMapOnLocation(location: CLLocation) {
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003))
        DispatchQueue.main.async {
            self.mapView.setRegion(region, animated: true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            self.mapView.addAnnotation(annotation)
        }
    }
    
    // delegate that draws/traces the path taken
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if (overlay is MKPolyline) {
            let pr = MKPolylineRenderer(overlay: overlay)
            pr.strokeColor = UIColor.red
            pr.lineWidth = 5
            return pr
        }
        return MKPolylineRenderer()
    }
    
}
