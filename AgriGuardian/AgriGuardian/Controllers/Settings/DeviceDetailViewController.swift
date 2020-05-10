//
//  DeviceDetailViewController.swift
//  
//
//  Created by Daniel Weatrowski on 4/25/20.
//

import UIKit
import MapKit
import CoreLocation

protocol gfDelegate
{
    func pullGFCenter(gfPoint: CLLocation)
}

protocol RefreshDataDelegate
{
    func refreshData()
}

class DeviceDetailViewController: UITableViewController, CLLocationManagerDelegate, gfDelegate {
    
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
    var isNew: Bool = false
    var viewDelegate: RefreshDataDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAuthLoc()
        setupView()
        self.deviceNameLabel.addDoneButtonOnKeyboard()
        self.vehicleModelLabel.addDoneButtonOnKeyboard()
        self.geofenceRadius.addDoneButtonOnKeyboard()

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

        if isNew {
            self.geofenceToggle.isOn = false
            self.deviceNameLabel.text = ""
            self.vehicleModelLabel.text = ""
        }
        else {
            self.geofenceToggle.isOn = thisDevice.gfToggle
            self.deviceNameLabel.text = thisDevice.name
            self.vehicleModelLabel.text = thisDevice.atvModel
            self.geofenceRadius.text = String(thisDevice.gfRadius)
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
        if let gfRad = geofenceRadius.text, geofenceRadius.text!.isNumber {
            vc.radius = Double(gfRad)!
        }
        else {
            vc.radius = 50 // TODO: Change
        }
        vc.currLoc = self.currLoc
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
        
    }
    func pullGFCenter(gfPoint: CLLocation) {
        self.gfCenter = gfPoint
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        print(self.gfCenter)
        print(self.geofenceRadius.text!)
 
//        var currDevice: Device = Device()
        if let devName = self.deviceNameLabel.text, !devName.isEmpty, let vehName = self.vehicleModelLabel.text, !vehName.isEmpty, let gfRad = geofenceRadius.text, geofenceRadius.text!.isnumberordouble {
            thisDevice.name = devName
            thisDevice.atvModel = vehName
            thisDevice.gfRadius = Double(gfRad)!
            thisDevice.gfToggle = self.geofenceToggle.isOn
            thisDevice.gfCenter = self.gfCenter
            if isNew {
                fbManager.addDevice(device: thisDevice)
            }
            else {
                fbManager.updateDevice(device: thisDevice)
            }
            viewDelegate?.refreshData()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func removeButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Please Confirm", message: "Are you sure you want to delete this device?", preferredStyle: .alert)


        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.fbManager.deleteDevice(device: self.thisDevice)
            self.viewDelegate?.refreshData()
            self.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            self.viewDelegate?.refreshData()
            self.dismiss(animated: true, completion: nil)
        }))


        self.present(alert, animated: true)
    }
    

    
    // MARK: - Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section) {
        case 0:
            break
        case 1:
            if (indexPath.row == 2) {
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
        // SET VARS HERE =======================================================
        let center = mapView.convert(mapView.centerCoordinate, toPointTo: pinView)
        pinView.center = CGPoint(x: center.x, y: center.y - (pinView.bounds.height/2))
        ellipsisLayer.position = center
        let region = MKCoordinateRegion(center: self.currLoc
            .coordinate, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        DispatchQueue.main.async {
            self.mapView.setRegion(region, animated: true)
        }
    }
    @objc func tappedDone(_ sender: UIBarButtonItem){
        let target2d = mapView.convert(ellipsisLayer.position, toCoordinateFrom: mapView)
        let target = CLLocation.init(latitude: target2d.latitude, longitude: target2d.longitude)
        delegate?.pullGFCenter(gfPoint: target)
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)

    }

    func updateTitle(){
        let fmt = NumberFormatter()
        fmt.maximumFractionDigits = 4
        fmt.minimumFractionDigits = 4
        let latitude = fmt.string(from: NSNumber(value: mapView.centerCoordinate.latitude))!
        let longitude = fmt.string(from: NSNumber(value: mapView.centerCoordinate.longitude))!
        title = "\(latitude), \(longitude)"
    }
    public func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        self.prevRadius = radius
        ellipsisLayer.transform = CATransform3DMakeScale(0.5, 0.5, 1)
//        ellipsisLayer.transform = CATransform3DMakeScale(CGFloat(0.5/mapView.region.span.longitudeDelta), CGFloat(0.5/mapView.region.span.longitudeDelta), 1)
        print("WILLCHANGE: \(mapView.region.span)")
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.pinView.center = CGPoint(x: self!.pinView.center.x, y: self!.pinView.center.y - 10)
            })
        self.prevDelta = mapView.region.span.longitudeDelta
    }

    public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("===========================================================")
        print("3NUM SUBVIEWS: \(mapView.subviews.count)")
        print("3NUM SUBLAYERS: \(mapView.layer.sublayers?.count)")
        mapView.layer.removeAllAnimations()
        mapView.willRemoveSubview(pinView)
//        mapView.subviews = mapView.subviews.dropLast()
//        pinView.removeFromSuperview()
        ellipsisLayer.removeFromSuperlayer()
        print("1NUM SUBVIEWS: \(mapView.subviews.count)")
        print("1NUM SUBLAYERS: \(mapView.layer.sublayers?.count)")
        
//        mapView.remove
//        ellipse.
        
        let oldEllipsis = ellipsisLayer
        let scaleW = self.radius/(100 * mapView.region.span.longitudeDelta)
        let scaleH = self.radius/(100 * mapView.region.span.longitudeDelta)
        self.width = CGFloat(scaleW)
        self.height = CGFloat(scaleH)
        
        
        // ==================================================
//        ellipsisLayer.bounds = CGRect(x: 0, y: 0, width: self.width, height: self.height)
        var newEllipse = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: CGFloat(self.currRadius), height: CGFloat(self.currRadius )))
        
        
        
        
        newEllipse = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: CGFloat(self.radius), height: CGFloat(self.radius )))
        // ==================================================
        
        
        
        ellipsisLayer.path = newEllipse.cgPath
        print("RADIUSSSSSSS: \(self.currRadius)")
        
        
        print("SCALING \(scaleW), \(scaleH)")
//        ellipse.apply(CGAffineTransform(scaleX: CGFloat(9999), y: CGFloat(9999)))
        ellipsisLayer.transform = CATransform3DIdentity

        print("PREV RADIUS: \(self.radius)")
//        self.radius = self.prevRadius/(100 * mapView.region.span.longitudeDelta)
//        self.prevRadius = self.radius
//
//        if mapView.region.span.longitudeDelta == 0.02 {
//            print("===========REGION UP IN HERE NOW========")
//            self.currRadius = 200
//        }
//        else {
//            var check = ((self.currDelta - self.prevDelta) * 10) + self.currRadius
//            if check < 0 {
//                self.currRadius = 200
//            }
//            else {
//                self.currRadius = ((self.currDelta - self.prevDelta) * 10) + self.currRadius
//            }
//            print("~~~~~~~~REGION DOWN IN HERE NOW~~~~~~~~~")
//        }
        print("CURR RADIUS: \(self.currRadius)")
//        mapView.addSubview(pinView)
        print("ADDING NEXT")
        mapView.layer.insertSublayer(ellipsisLayer, below: pinView.layer)
        print("2NUM SUBVIEWS: \(mapView.subviews.count)")
        print("2NUM SUBLAYERS: \(mapView.layer.sublayers?.count)")
        

        self.currDelta = mapView.region.span.longitudeDelta
        print("DIDCHANGE: \(mapView.region.span)")
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.pinView.center = CGPoint(x: self!.pinView.center.x, y: self!.pinView.center.y + 10)
            })
        updateTitle()
    }
    
}
extension String  {
    var isNumber: Bool {
        print("CHECKING NUMBER")
        let check = !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        print(check)
        return check
    }
    var isnumberordouble: Bool { return Double(self.trimmingCharacters(in: .whitespaces)) != nil }
}

extension UITextField{
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }

    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}
