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
    func loadTraceRoute() -> [CLLocation]
}

class RideDetailMapCVC: UICollectionViewCell, MKMapViewDelegate{
    
    // MARK: - Properties
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapButton: UIButton!
    var mapDelegate: MapCellDelegate?
    var dataManager = DataManager()
    var ride: Ride = Ride()
    var locations: [CLLocation] = []
    
    
    // TESTING
    var currUID: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        print("555555555")
//        let ride = dataManager.loadGPSData(csvFile: "gps_2020_03_09", ofType: "csv")
//        let locations = ride.locations
//        print("666666666")
        
        
        mapView.delegate = self
       // locations = (mapDelegate?.loadTraceRoute())!
//        let initialLoc = CLLocation(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
//        self.centerMapOnLocation(location: initialLoc)
        
        
       // self.loadRoute(coords: locations)
        
    }
    
    @IBAction func didSelectMap(_ sender: Any) {
        mapDelegate?.didTapMap(sender)
    }
    
    func loadRoute(coords: [CLLocation], miles: Double) {
        let initialLoc = CLLocation(latitude: coords[0].coordinate.latitude, longitude: coords[0].coordinate.longitude)
        let center = CLLocation(latitude: coords[coords.count/2].coordinate.latitude, longitude: coords[coords.count/2].coordinate.longitude)
        //coords.count/2
        
//        if let lati = coords.last?.coordinate.latitude, let long = coords.last?.coordinate.longitude {
//            let finalLoc = CLLocation(latitude: lati, longitude: long)
//        }

        self.centerMapOnLocation(location: initialLoc, center: center, miles: miles)
        
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
    
    
    
    
    func centerMapOnLocation(location: CLLocation, center: CLLocation, miles: Double) {
        var latD: Double = 0.1
        var longD: Double = 0.1
        print("MILES: \(miles)")
        if miles < 1 {
            latD = 0.003
            longD = 0.003
        } else { // figure out better metrics? for larger miles greater than 2.6
            latD = 0.02 * miles
            longD = 0.02 * miles
        }
        let region = MKCoordinateRegion(center: center.coordinate, span: MKCoordinateSpan(latitudeDelta: latD, longitudeDelta: longD))
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
