//
//  MapLocationViewController.swift
//  AgriGuardian
//
//  Created by Davy Chuon on 2/28/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseAuth
import MapKit
import CoreLocation

class MapLocationViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    // MARK: OUTLETS / VARIABLES
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var locationHistory = [CLLocation]()
    
    var ref: DocumentReference? = nil
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.delegate = self;
        self.setupAuth()
        self.setupMap()
    }
    
    // MARK: ACTIONS
    
    
    // MARK: FUNCTIONS
    
    // setup authorization to request user for permission of services
    func setupAuth() {
        // user activated automatic authorization info mode for location services
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined || status == .denied || status == .authorizedWhenInUse {
            // present an alert indicating location authorization required
            // and offer to take the user to Settings for the app via
            // UIApplication -openUrl: and UIApplicationOpenSettingsURLString
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
    
    // setup for live display of user location on map
    func setupMap() {
        //mapview setup to show user location
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.mapType = MKMapType(rawValue: 0)!
        mapView.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
    }
    
    //function to add annotation to map view
    func addAnnotationsOnMap(locationToPoint : CLLocation){

        let annotation = MKPointAnnotation()
        annotation.coordinate = locationToPoint.coordinate
        let geoCoder = CLGeocoder ()
        geoCoder.reverseGeocodeLocation(locationToPoint, completionHandler: { (placemarks, error) -> Void in
            if let placemarks = placemarks, placemarks.count > 0 {
                let placemark = placemarks[0]
                let addressDictionary = placemark.addressDictionary;
                annotation.title = addressDictionary?["Name"] as? String
                self.mapView.addAnnotation(annotation)
            }
        })
    }
    
    
    func addToRH(loc: CLLocation) {
        let ref = Firestore.firestore().collection("ridehistory").document("test")
        ref.setData([
            "coord" : FieldValue.arrayUnion([GeoPoint.init(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude)])
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref.documentID)")
                
            }
        }
        
    }
    
    func updateToRH(loc: CLLocation) {
        let ref = Firestore.firestore().collection("ridehistory").document("test")
        ref.updateData([
            "coord" : FieldValue.arrayUnion([GeoPoint.init(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude)])
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref.documentID)")
                
            }
        }
        
    }
    
    
    // MARK: DELEGATES
    
    // delegate that updates current location with new coordinates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations newLocation: [CLLocation]) {
        if locationHistory.count == 2 {
            locationHistory.removeFirst()
            
            
            // TESTING
            if let loc = newLocation.last {
                self.updateToRH(loc: loc)
            }
        }
        else {
            // TESTING CONDITION CLAUSE
            self.addToRH(loc: newLocation[0])
        }
        
        for i in newLocation {
            print("present location : \(i.coordinate.latitude), \(i.coordinate.longitude)")
            locationHistory.append(i)
        }
        
//        print("===Size===: \(locationHistory.count)")
//        for j in locationHistory {
//            print("locHistory: \(j)")
//        }
        
        if locationHistory.count == 2 {
            let oldCoords = locationHistory[0].coordinate
            let newCoords = locationHistory[1].coordinate
            var area = [oldCoords, newCoords]
            let polyline = MKPolyline(coordinates: &area, count: area.count)
            mapView.addOverlay(polyline)
        } else {
            // old location == new location (initially)
            let oldCoords = locationHistory[0].coordinate
            let newCoords = oldCoords
            var area = [oldCoords, newCoords]
            let polyline = MKPolyline(coordinates: &area, count: area.count)
            mapView.addOverlay(polyline)
        }
        
//        self.addAnnotationsOnMap(locationToPoint: newLocation[0])
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
