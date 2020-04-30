//
//  DeviceDetailViewController.swift
//  
//
//  Created by Daniel Weatrowski on 4/25/20.
//

import UIKit
import MapKit
import CoreLocation

class DeviceDetailViewController: UITableViewController, CLLocationManagerDelegate {
    // MARK: - Properties
    var thisDevice: Device = Device()
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var removeDeviceCell: UITableViewCell!
    @IBOutlet weak var deviceNameLabel: UITextField!
    @IBOutlet weak var vehicleModelLabel: UITextField!
    @IBOutlet weak var geofenceToggle: UISwitch!
    @IBOutlet weak var geofenceRadius: UITextField!
    
    
    var locationManager: CLLocationManager = CLLocationManager()
    var currLoc: CLLocation = CLLocation()
    var isNew: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAuthLoc()
        setupView()

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
        self.geofenceToggle.isOn = false
        self.deviceNameLabel.text = ""
        self.vehicleModelLabel.text = ""
        
        if (!isNew) {
            self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        navigationController?.pushViewController(vc, animated: true)
        
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
    var prevRadius: Double = 0.0
    var currLoc: CLLocation = CLLocation()
    
    lazy var mapView : MKMapView = { [unowned self] in
        let v = MKMapView(frame: self.view.bounds)
        v.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return v
        }()
    
    lazy var pinView: UIImageView = { [unowned self] in
        let v = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))

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
        let ellipse = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: CGFloat(self.radius), height: CGFloat(self.radius)))
        return ellipse
        }()


    lazy var ellipsisLayer: CAShapeLayer = { [unowned self] in
        let layer = CAShapeLayer()


        self.width = CGFloat(radius)
        self.height = CGFloat(radius)

        
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
        let target = mapView.convert(ellipsisLayer.position, toCoordinateFrom: mapView)
        // GET COORDS AND RETURN
//        row.value = CLLocation(latitude: target.latitude, longitude: target.longitude)
//        onDismissCallback?(self)
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
    }

    public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        mapView.layer.removeAllAnimations()
        mapView.willRemoveSubview(pinView)
//        mapView.remove
//        ellipse.
        
        let oldEllipsis = ellipsisLayer
        let scaleW = self.radius/(100 * mapView.region.span.longitudeDelta)
        let scaleH = self.radius/(100 * mapView.region.span.longitudeDelta)
        print("SCALING \(scaleW), \(scaleH)")
        ellipse.apply(CGAffineTransform(scaleX: CGFloat(scaleW), y: CGFloat(scaleH)))
        ellipsisLayer.transform = CATransform3DIdentity
        self.radius = self.prevRadius/(100 * mapView.region.span.longitudeDelta)
        self.prevRadius = self.radius
        mapView.addSubview(pinView)
        mapView.layer.insertSublayer(ellipsisLayer, below: pinView.layer)
        
        
//        mapView.layer.insertSublayer(ellipsisLayer, below: pinView.layer)
//        mapView.layer.replaceSublayer(oldEllipsis, with: ellipsisLayer)
        
        
        
        print("DIDCHANGE: \(mapView.region.span)")
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.pinView.center = CGPoint(x: self!.pinView.center.x, y: self!.pinView.center.y + 10)
            })
        updateTitle()
    }
    
}
extension String  {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
