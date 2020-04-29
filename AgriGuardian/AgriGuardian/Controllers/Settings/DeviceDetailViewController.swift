//
//  DeviceDetailViewController.swift
//  
//
//  Created by Daniel Weatrowski on 4/25/20.
//

import UIKit
import MapKit

class DeviceDetailViewController: UITableViewController {
    // MARK: - Properties
    var thisDevice: Device = Device()
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var removeDeviceCell: UITableViewCell!
    var isNew: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
    }
    
    fileprivate func setupView() {
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
        vc.radius = 50 // TODO: Change
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
    
    var radius: Double?
    
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
        let ellipse = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: self.width, height: self.height))
        return ellipse
        }()


    lazy var ellipsisLayer: CAShapeLayer = { [unowned self] in
        let layer = CAShapeLayer()

        if let rad = radius {
            self.width = CGFloat(rad)
            self.height = CGFloat(rad)
        }
        
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
    }
    @objc func tappedDone(_ sender: UIBarButtonItem){
        let target = mapView.convert(ellipsisLayer.position, toCoordinateFrom: mapView)
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
    }
    
}
