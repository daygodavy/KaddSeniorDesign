//
//  GeofencingViewController.swift
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

class GeofencingViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    // MARK: OUTLETS / VARIABLES
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var message: UILabel!
    var locationManager: CLLocationManager = CLLocationManager()
    
    let ENTERED_REGION_MESSAGE = "Welcome to Playa Grande! If the waves are good, you can try surfing!"
    let ENTERED_REGION_NOTIFICATION_ID = "EnteredRegionNotification"
    let EXITED_REGION_MESSAGE = "Bye! Hope you had a great day at the beach!"
    let EXITED_REGION_NOTIFICATION_ID = "ExitedRegionNotification"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.delegate = self;
        self.setupAuth()
        self.message.text = "JUST STARTING OFF HERE"
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
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
    
    func setUpGeofenceForPlayaGrandeBeach() {
        let geofenceRegionCenter = CLLocationCoordinate2DMake(37.33020932, -122.03406010);
        let geofenceRegion = CLCircularRegion(center: geofenceRegionCenter, radius: 400, identifier: "CurrentLocation");
        geofenceRegion.notifyOnExit = true;
        geofenceRegion.notifyOnEntry = true;
        
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let mapRegion = MKCoordinateRegion(center: geofenceRegionCenter, span: span)
        self.mapView.setRegion(mapRegion, animated: true)
        
        let regionCircle = MKCircle(center: geofenceRegionCenter, radius: 13000)
        self.mapView.addOverlay(regionCircle)
        self.mapView.showsUserLocation = true;
        
        self.locationManager.startMonitoring(for: geofenceRegion)
    }
    
    
    // MARK: DELEGATES
    
    // delegate for the map view
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let overlayRenderer : MKCircleRenderer = MKCircleRenderer(overlay: overlay);
        overlayRenderer.lineWidth = 4.0
        overlayRenderer.strokeColor = UIColor(red: 7.0/255.0, green: 106.0/255.0, blue: 255.0/255.0, alpha: 1)
        overlayRenderer.fillColor = UIColor(red: 0.0/255.0, green: 203.0/255.0, blue: 208.0/255.0, alpha: 0.7)
        return overlayRenderer
    }
    
    //MARK - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.authorizedAlways) {
            //App Authorized, stablish geofence
            self.setUpGeofenceForPlayaGrandeBeach()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("Started Monitoring Region: \(region.identifier)")
        print("REGION HERE: \(region.identifier.description)")
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print(ENTERED_REGION_MESSAGE)
        self.message.text = ENTERED_REGION_MESSAGE
        self.createLocalNotification(message: ENTERED_REGION_MESSAGE, identifier: ENTERED_REGION_NOTIFICATION_ID)
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print(EXITED_REGION_MESSAGE)
        self.message.text = EXITED_REGION_MESSAGE
        self.createLocalNotification(message: EXITED_REGION_MESSAGE, identifier: EXITED_REGION_NOTIFICATION_ID)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.message.text = ""
    }
    
    func createLocalNotification(message: String, identifier: String) {
        //Create a local notification
        let content = UNMutableNotificationContent()
        content.body = message
        content.sound = UNNotificationSound.default
        
        // Deliver the notification
        let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: nil)
        
        // Schedule the notification
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
        }
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
