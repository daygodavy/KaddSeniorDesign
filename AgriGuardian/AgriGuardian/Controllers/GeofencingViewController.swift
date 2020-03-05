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
        
        // TESTING
        if let userLoc = locationManager.location?.coordinate {
            print("USER LOC: \(userLoc.latitude) \(userLoc.longitude)")
            let viewRegion = MKCoordinateRegion.init(center: userLoc, latitudinalMeters: 5000, longitudinalMeters: 5000)
            mapView.setRegion(viewRegion, animated: true)
        }
        self.mapView.showsUserLocation = true
        locationManager.startUpdatingLocation()
        //        locationManager.startUpdatingHeading()
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        mapView.addGestureRecognizer(longTapGesture)
        
        
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
    
    //    func setUpGeofenceForPlayaGrandeBeach() {
    //        let geofenceRegionCenter = CLLocationCoordinate2DMake(37.33020932, -122.03406010);
    //        let geofenceRegion = CLCircularRegion(center: geofenceRegionCenter, radius: 400, identifier: "CurrentLocation");
    //        geofenceRegion.notifyOnExit = true;
    //        geofenceRegion.notifyOnEntry = true;
    //
    //        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    //        let mapRegion = MKCoordinateRegion(center: geofenceRegionCenter, span: span)
    //        self.mapView.setRegion(mapRegion, animated: true)
    //
    //        let regionCircle = MKCircle(center: geofenceRegionCenter, radius: 13000)
    //        self.mapView.addOverlay(regionCircle)
    //        self.mapView.showsUserLocation = true;
    //
    //        self.locationManager.startMonitoring(for: geofenceRegion)
    //    }
    
    
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
            
            //            self.setUpGeofenceForPlayaGrandeBeach()
            
            
            
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
    
    
    // TESTING PLACING GEOFENCE PIN AT A PARTICULAR LOCATION
    func setUpGF(loc: CLLocationCoordinate2D, rad: Double) {
        //        let geofenceRegionCenter = CLLocationCoordinate2DMake(37.33020932, -122.03406010);
        let geofenceRegion = CLCircularRegion(center: loc, radius: rad, identifier: "CurrentLocation")
        geofenceRegion.notifyOnExit = true
        geofenceRegion.notifyOnEntry = true
        
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let mapRegion = MKCoordinateRegion(center: loc, span: span)
        self.mapView.setRegion(mapRegion, animated: true)
        
        let regionCircle = MKCircle(center: loc, radius: rad)
        self.mapView.addOverlay(regionCircle)
        self.mapView.showsUserLocation = true
        
        self.locationManager.startMonitoring(for: geofenceRegion)
    }
    
    // MARK: TEST FUNCS
    @objc func longTap(sender: UIGestureRecognizer){
        print("long tap")
        if sender.state == .began {
            let locationInView = sender.location(in: mapView)
            let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
            
            print("ANNOTATE COUNT: \(mapView.annotations.count)")
            print("OVERLAY COUNT: \(mapView.overlays.count)")
            if mapView.annotations.count > 1 {
                confirmNewPlacemark(location: locationOnMap)
            }
            else {
                confirmPlacemark(location: locationOnMap)
            }
            //            addAnnotation(location: locationOnMap)
        }
    }
    
    func addAnnotation(location: CLLocationCoordinate2D, rad: Double){
        self.setUpGF(loc: location, rad: rad)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Some Title"
        annotation.subtitle = "Some Subtitle"
        self.mapView.addAnnotation(annotation)
    }
    
    func confirmPlacemark(location: CLLocationCoordinate2D){
        let alertController = UIAlertController(title: "Enter a radius for your geofence", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Radius (in meters)"
        }
        
        let cancelAction = UIAlertAction(title: "No", style: .default, handler: nil )
        
        let saveAction = UIAlertAction(title: "Yes", style: .default, handler: { alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            print("textfield: \(firstTextField.text)")
            if let radius = firstTextField.text, !radius.isEmpty {
                if let doubleRad = Double(radius) {
                    self.addAnnotation(location: location, rad: doubleRad)
                }
                //                self.createDeviceProfile(name: name)
            }
            
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func confirmNewPlacemark(location: CLLocationCoordinate2D) {
        let alertController = UIAlertController(title: "Are you sure you want to change your existing geofence?", message: "", preferredStyle: .alert)
        
        
//        alertController.addTextField { (textField : UITextField!) -> Void in
//            textField.placeholder = "Radius (in meters)"
//        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil )
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            self.mapView.removeAnnotation(self.mapView.annotations[1])
            self.mapView.removeOverlay(self.mapView.overlays[0])
            self.confirmPlacemark(location: location)
            
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: TEST DELEGATES
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { print("no mkpointannotaions"); return nil }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .infoDark)
            pinView!.pinTintColor = UIColor.systemPink
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("tapped on pin ")
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let doSomething = view.annotation?.title! {
                print("do something")
            }
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
