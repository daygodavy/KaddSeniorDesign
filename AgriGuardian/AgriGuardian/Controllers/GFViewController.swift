//
//  GFViewController.swift
//  AgriGuardian
//
//  Created by Davy Chuon on 2/29/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseAuth
import MapKit
import CoreLocation

class GFViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.delegate = self;
        self.setupAuth()
        self.setupMap()
        self.setupGF()
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
    
    func setupGF() {
        locationManager.distanceFilter = 100
        let center = CLLocationCoordinate2DMake(37.33182081, -122.03038642)
        let geoFenceRegion: CLCircularRegion = CLCircularRegion(center: center, radius: 100, identifier: "Cali")
        geoFenceRegion.notifyOnExit = true
        geoFenceRegion.notifyOnEntry = true
        
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let mapRegion = MKCoordinateRegion(center: center, span: span)
        self.mapView.setRegion(mapRegion, animated: true)
        
        let regionCircle = MKCircle(center: center, radius: 400)
        self.mapView.addOverlay(regionCircle)
        self.mapView.showsUserLocation = true
        
        locationManager.startMonitoring(for: geoFenceRegion)
        
    }

    
    // MARK: DELEGATES
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for currLoc in locations {
            print("\(index): \(currLoc)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("ENTER REGION ID: \(region.identifier)")
    }
    
    func locationManager(_ mananger: CLLocationManager, didExitRegion region: CLRegion) {
        print("EXIT REGION ID: \(region.identifier)")
    }
    
    //MARK - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let overlayRenderer : MKCircleRenderer = MKCircleRenderer(overlay: overlay);
        overlayRenderer.lineWidth = 4.0
        overlayRenderer.strokeColor = UIColor(red: 7.0/255.0, green: 106.0/255.0, blue: 255.0/255.0, alpha: 1)
        overlayRenderer.fillColor = UIColor(red: 0.0/255.0, green: 203.0/255.0, blue: 208.0/255.0, alpha: 0.7)
        return overlayRenderer
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
