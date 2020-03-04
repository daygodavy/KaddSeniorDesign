//
//  RideMapViewController.swift
//  AgriGuardian
//
//  Created by Daniel Weatrowski on 3/2/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class RideMapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: - Properties
    var mapView: MKMapView = MKMapView()
    
    // TESTING
    var ref: DocumentReference? = nil
    let db = Firestore.firestore()
    var currUID: String = ""
    var coordPoints: [GeoPoint] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView = MKMapView(frame: self.view.frame)
        self.view.addSubview(mapView)

        // TESTING
        mapView.delegate = self
        let initialLoc = CLLocation(latitude: 37.33065643, longitude: -122.03064682)
        self.centerMapOnLocation(location: initialLoc)
        self.loadProfiles()
    }
    
        // TESTING
        func loadProfiles() {
            print("LOADING PROFILES IN CELL")
            if let id = Auth.auth().currentUser?.uid {
                self.currUID = id
            }
            let root = Firestore.firestore().collection("ridehistory").document("test")
            root.getDocument() {doc, error in
                if let err = error {
                    print("\(err)")
                }
                
                let arr = doc?.get("coord") as! [Any]
                for coord in arr {
                    let point = coord as! GeoPoint
    //                print("point \(point)")
                    self.coordPoints.append(point)
    //                print("coordPOINTS")
    //                print(self.coordPoints)
                    
    //                let lat = point.latitude
    //                let long = point.longitude
    //                print(lat, long)
                }
                self.drawPath()
            }
        }
        
        func drawPath() {
            var endToEndPath: [CLLocation] = []
    //        var currPoint: CLLocation
    //        print("COORDPOINTS")
    //        print(self.coordPoints)
            for coord in self.coordPoints {
                
    //            currPoint.coordinate.longitude = coord.longitude
    //            currPoint.coordinate.latitude = coord.latitude
    //            endToEndPath.append(currPoint)
                endToEndPath.append(CLLocation.init(latitude: coord.latitude, longitude: coord.longitude))
                if endToEndPath.count == 2 {
                    let prev = endToEndPath[0].coordinate
                    let curr = endToEndPath[1].coordinate
                    let area = [prev, curr]
                    let polyline = MKPolyline(coordinates: area, count: area.count)
                    mapView.addOverlay(polyline)
                }
                else {
                    endToEndPath.append(CLLocation.init(latitude: coord.latitude, longitude: coord.longitude))
                    let prev = endToEndPath[0].coordinate
                    let curr = endToEndPath[1].coordinate
                    let area = [prev, curr]
                    let polyline = MKPolyline(coordinates: area, count: area.count)
                    mapView.addOverlay(polyline)
                }
                print("END TO END PATH")
                print(endToEndPath)
                endToEndPath.removeFirst()
            }
        }
    
     func centerMapOnLocation(location: CLLocation) {
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
