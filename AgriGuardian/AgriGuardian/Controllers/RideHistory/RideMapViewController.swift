//
//  RideMapViewController.swift
//  AgriGuardian
//
//  Created by Daniel Weatrowski on 3/2/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit
import MapKit

class RideMapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: - Properties
    var mapView: MKMapView = MKMapView()
    var dataManager = DataManager()
//    var mapDelegate: MapCellDelegate?
//    var dataManager = DataManager()
    var ride: Ride = Ride()
    var locations: [CLLocation] = []
    var miles: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView = MKMapView(frame: self.view.frame)
        self.view.addSubview(mapView)
        
//        let ride = dataManager.loadGPSData(csvFile: "gps_2020_03_09", ofType: "csv")
//        let locations = ride.locations
        
        
        // TESTING
        mapView.delegate = self
        let initialLoc = CLLocation(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let center = CLLocation(latitude: locations[locations.count/2].coordinate.latitude, longitude: locations[locations.count/2].coordinate.longitude)
        self.centerMapOnLocation(location: initialLoc, center: center)
        print(locations.count)
        
        self.loadRoute(coords: locations)
        
        // Do any additional setup after loading the view.
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
    
    func centerMapOnLocation(location: CLLocation, center: CLLocation) {
        var latD: Double = 0.1
        var longD: Double = 0.1
        print("MILES: \(self.miles)")
        if self.miles < 1 {
            latD = 0.003
            longD = 0.003
        } else { // figure out better metrics? for larger miles greater than 2.6
            latD = 0.03 * self.miles
            longD = 0.03 * self.miles
        }
        
        
        let region = MKCoordinateRegion(center: center.coordinate, span: MKCoordinateSpan(latitudeDelta: latD, longitudeDelta: longD))
        DispatchQueue.main.async {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            self.mapView.addAnnotation(annotation)
            self.mapView.setRegion(region, animated: true)
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
