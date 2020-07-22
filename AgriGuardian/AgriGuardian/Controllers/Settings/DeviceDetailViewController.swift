//
//  DeviceDetailViewController.swift
//  
//
//  Created by Daniel Weatrowski on 4/25/20.
//

import UIKit
import MapKit
import CoreLocation
import CoreBluetooth
import Firebase

protocol gfDelegate
{
    func pullGFCenter(gfPoint: CLLocation, gfRad: Double)
}

protocol RefreshDataDelegate
{
    func refreshData()
}

class DeviceDetailViewController: UITableViewController, CLLocationManagerDelegate, UITextFieldDelegate, gfDelegate {
    
    // MARK: - Properties
    var thisDevice: Device = Device()
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var removeDeviceCell: UITableViewCell!
    @IBOutlet weak var deviceNameLabel: UITextField!
    @IBOutlet weak var vehicleModelLabel: UITextField!
    @IBOutlet weak var geofenceToggle: UISwitch!
    @IBOutlet weak var geofenceRadius: UITextField!
    
    var fbManager: FirebaseManager = FirebaseManager()
    var locationManager: CLLocationManager = CLLocationManager()
    var currLoc: CLLocation = CLLocation()
    var gfCenter: CLLocation = CLLocation()
    var gfRad: Double = 0.0
    var isNew: Bool = false
    var viewDelegate: RefreshDataDelegate?
    var ellipseSize: Double = 410.0
    
    var enableBluetooth = false
    
    // BLE
    var kaddCharacteristic: CBCharacteristic!
    var kaddPeripheral: CBPeripheral!
    var serialNumber = ""
    var modelNumber = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAuthLoc()
        setupView()
        self.deviceNameLabel.addDoneButtonOnKeyboard()
        self.vehicleModelLabel.addDoneButtonOnKeyboard()
//        self.geofenceRadius.addDoneButtonOnKeyboard()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
    }
    
    func setupAuthLoc() {
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            if let loc = locationManager.location {
                currLoc = loc
            }
        }
    }
    fileprivate func setupView() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelNavButtonPressed))
//            navigationItem.rightBarButtonItem =
        
        deviceNameLabel.delegate = self
        vehicleModelLabel.delegate = self
//        geofenceRadius.delegate = self
        var endPosition = deviceNameLabel.endOfDocument
        deviceNameLabel.selectedTextRange = deviceNameLabel.textRange(from: endPosition, to: endPosition)
        endPosition = vehicleModelLabel.endOfDocument
        vehicleModelLabel.selectedTextRange = vehicleModelLabel.textRange(from: endPosition, to: endPosition)
//        endPosition = geofenceRadius.endOfDocument
//        geofenceRadius.selectedTextRange = geofenceRadius.textRange(from: endPosition, to: endPosition)
        
        if isNew {
            self.geofenceToggle.isOn = false
            self.deviceNameLabel.text = ""
            self.vehicleModelLabel.text = ""
        }
        else {
            self.geofenceToggle.isOn = thisDevice.gfToggle
            self.deviceNameLabel.text = thisDevice.name
            self.vehicleModelLabel.text = thisDevice.atvModel
//            self.geofenceRadius.text = String(thisDevice.gfRadius)
            self.gfCenter = thisDevice.gfCenter
        }
        
        if (!isNew) {
//            self.navigationItem.rightBarButtonItem = self.editButtonItem
            self.submitButton.setTitle("Save", for: .normal)
            self.removeButton.setTitle("Remove Device", for: .normal)
            self.removeButton.tintColor = .systemRed
        } else {
            removeDeviceCell.isHidden = true
        }
        self.submitButton.setTitle("Save", for: .normal)


    }
    fileprivate func segueToGeofencing() {
        let vc = GeofenceController()
        vc.title = "Set Geofence"

        vc.radius = self.ellipseSize
        vc.currLoc = self.currLoc
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
        
    }
    func pullGFCenter(gfPoint: CLLocation, gfRad: Double) {
        self.gfCenter = gfPoint
        self.gfRad = gfRad
    }
    @objc func cancelNavButtonPressed() {
        presentCustomAlert(title: "Are you sure?", message: "Any changes made will not be saved") {
            // OK was pressed
            self.navigationController?.popViewController(animated: true)
        }
        // otherwise cancel, nothing happens
        
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        print(self.gfCenter)
//        print(self.geofenceRadius.text!)
 
//        var currDevice: Device = Device()
        if let devName = self.deviceNameLabel.text, !devName.isEmpty, let vehName = self.vehicleModelLabel.text, !vehName.isEmpty {
            thisDevice.name = devName
            thisDevice.atvModel = vehName
            thisDevice.gfRadius = self.gfRad
            thisDevice.gfToggle = self.geofenceToggle.isOn
            thisDevice.gfCenter = self.gfCenter
            let user = Auth.auth().currentUser!.uid
            if isNew {
                // TODO: Write data to pi here
                // NOTE: 7/21/20 - change thisDevice.name to unique devID in firebase
                let tokens =  "\(user), \(thisDevice.name), \(thisDevice.gfRadius), \(thisDevice.gfCenter.coordinate.latitude), \(thisDevice.gfCenter.coordinate.longitude), 9999999999"
                print("Writing to peripheral")
                let data = Data(tokens.utf8)
                if (enableBluetooth) {
                    kaddPeripheral.writeValue(data, for: kaddCharacteristic, type: .withResponse)
                    print("================ KADDPERIPHERAL VALUE WRITTEN ================")
                }
                // disconnect device?
                fbManager.addDevice(device: thisDevice)
            }
            else {
                fbManager.updateDevice(device: thisDevice)
            }
            viewDelegate?.refreshData()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    @IBAction func removeButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Please Confirm", message: "Are you sure you want to delete this device?", preferredStyle: .alert)


        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.fbManager.deleteDevice(device: self.thisDevice)
            self.viewDelegate?.refreshData()
            self.navigationController?.popViewController(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            self.viewDelegate?.refreshData()
            self.dismiss(animated: true, completion: nil)
        }))


        self.present(alert, animated: true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        var endPosition = deviceNameLabel.endOfDocument
        deviceNameLabel.selectedTextRange = deviceNameLabel.textRange(from: endPosition, to: endPosition)
        endPosition = vehicleModelLabel.endOfDocument
        vehicleModelLabel.selectedTextRange = vehicleModelLabel.textRange(from: endPosition, to: endPosition)
//        endPosition = geofenceRadius.endOfDocument
//        geofenceRadius.selectedTextRange = geofenceRadius.textRange(from: endPosition, to: endPosition)
        if textField == deviceNameLabel {
            print("pressed1")

        } else if textField == vehicleModelLabel {
            print("pressed2")
        }
//        else if textField == geofenceRadius {
//            print("pressed3")
//        }
    }

    

    
    // MARK: - Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section) {
        case 0:
            break
        case 1:
            if (indexPath.row == 1) {
                // segue to map view on select
                segueToGeofencing()
            }
            break
        case 2:
            break
        default:
            break
        }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}

public class GeofenceController: UIViewController, MKMapViewDelegate {
    
    var radius: Double = 0.0
    var nextRadius: Double = 0.0
    var currRadius: Double = 0.0
    var prevRadius: Double = 0.0
    var currDelta: Double = 0.0
    var prevDelta: Double = 0.0
    var currLoc: CLLocation = CLLocation()
    var delegate: gfDelegate?
    var startScaling: Bool = false
    var currScaleSize: Double = 1.0
    
    lazy var mapView : MKMapView = { [unowned self] in
        var v = MKMapView(frame: self.view.bounds)
        v.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return v
        }()
    
    lazy var pinView: UIImageView = { [unowned self] in
        var v = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))

        v.image = UIImage(systemName: "mappin")
        
        v.image = v.image?.withRenderingMode(.alwaysTemplate)
        v.tintColor = self.view.tintColor
        v.backgroundColor = .clear
        v.clipsToBounds = true
        v.contentMode = .scaleAspectFit
        v.isUserInteractionEnabled = false
        return v
        }()
    
    var width: CGFloat = 0
    var height: CGFloat = 0

    lazy var ellipse: UIBezierPath = { [unowned self] in
        var ellipse = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: CGFloat(self.radius), height: CGFloat(self.radius)))
        return ellipse
        }()


    lazy var ellipsisLayer: CAShapeLayer = { [unowned self] in
        var layer = CAShapeLayer()


        self.width = CGFloat(radius)
        self.height = CGFloat(radius)
        self.currRadius = self.radius
        self.currDelta = 0.02
        
        layer.bounds = CGRect(x: 0, y: 0, width: self.width, height: self.height)
        layer.path = self.ellipse.cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.fillRule = .nonZero
        layer.lineCap = .butt
        layer.lineDashPattern = nil
        layer.lineDashPhase = 0.0
        layer.lineJoin = .miter
        layer.lineWidth = 1.0
        layer.miterLimit = 10.0
        layer.strokeColor = UIColor.red.cgColor
        return layer
        }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)

        mapView.delegate = self
        mapView.addSubview(pinView)
        mapView.layer.insertSublayer(ellipsisLayer, below: pinView.layer)

        let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(GeofenceController.tappedDone(_:)))
        button.title = "Done"
        navigationItem.rightBarButtonItem = button
    
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let center = mapView.convert(mapView.centerCoordinate, toPointTo: pinView)
        pinView.center = CGPoint(x: center.x, y: center.y - (pinView.bounds.height/2))
        ellipsisLayer.position = center
        let region = MKCoordinateRegion(center: self.currLoc
            .coordinate, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        DispatchQueue.main.async {
            self.mapView.setRegion(region, animated: true)
            self.startScaling = true
        }
    }
    @objc func tappedDone(_ sender: UIBarButtonItem){
        let target2d = mapView.convert(ellipsisLayer.position, toCoordinateFrom: mapView)
        let target = CLLocation.init(latitude: target2d.latitude, longitude: target2d.longitude)
        delegate?.pullGFCenter(gfPoint: target, gfRad: self.mapView.region.distanceMax())
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }

    func updateTitle(){
//        let fmt = NumberFormatter()
//        fmt.maximumFractionDigits = 4
//        fmt.minimumFractionDigits = 4
//        let latitude = fmt.string(from: NSNumber(value: mapView.centerCoordinate.latitude))!
//        let longitude = fmt.string(from: NSNumber(value: mapView.centerCoordinate.longitude))!
//        title = "\(latitude), \(longitude)"
        title = "\(self.mapView.region.distanceMax()) METERS"
    }
    
    
    
    
    public func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {

        ellipsisLayer.transform = CATransform3DMakeScale(0.5, 0.5, 1)
        
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.pinView.center = CGPoint(x: self!.pinView.center.x, y: self!.pinView.center.y - 10)
            })
    }
    

    public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {

        ellipsisLayer.transform = CATransform3DIdentity

        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.pinView.center = CGPoint(x: self!.pinView.center.x, y: self!.pinView.center.y + 10)
            })
        updateTitle()
        
        print("DISTANCE MAX ======== \(self.mapView.region.distanceMax())")
    }
    
}


extension MKCoordinateRegion {
    func distanceMax() -> CLLocationDistance {
//        let furthest = CLLocation(latitude: center.latitude + (span.latitudeDelta/2),
//                             longitude: center.longitude + (span.longitudeDelta/2))
        let furthest = CLLocation(latitude: center.latitude, longitude: center.longitude + (span.longitudeDelta/2))
        let centerLoc = CLLocation(latitude: center.latitude, longitude: center.longitude)
        
        return trunc(centerLoc.distance(from: furthest))
    }
}
