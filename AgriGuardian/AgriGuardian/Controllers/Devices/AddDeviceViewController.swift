////
////  AddDeviceTableViewController.swift
////  AgriGuardian
////
////  Created by Daniel Weatrowski on 2/25/20.
////  Copyright © 2020 Team Kadd. All rights reserved.
////
//
//import UIKit
//import CoreLocation
//import MapKit
//import Firebase
//import CoreBluetooth
//
//class AddDeviceViewController: FormViewController, CLLocationManagerDelegate {
//
//    // MARK: - Properties
//    var ref: DocumentReference? = nil
//    let db = Firestore.firestore()
//    var thisDevice = Device()
//    let hardwareVersion = "1.0.0"
//    let firmwareVersion = "1.0.0"
//    var modelNumber = "A1"
//    var serialNumber = "AAKS776WJW8P00"
//    let manufacturer = "Kadd Inc."
//    var locationManager: CLLocationManager!
//    var currLoc: CLLocation = CLLocation()
//    var gfRad: String = ""
//
//    // BLE
//    var kaddService: CBUUID = CBUUID(string: "27cf08c1-076a-41af-becd-02ed6f6109b9")
//    var kaddCharacteristic: CBCharacteristic!
//    var kaddPeripheral: CBPeripheral!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupNavBar()
//        setupAuthLoc()
//
//        self.title = "Add Device"
//    }
//
//    // MARK: TESTING
//    func setupAuthLoc() {
//        if (CLLocationManager.locationServicesEnabled())
//        {
//            locationManager = CLLocationManager()
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager.requestAlwaysAuthorization()
//            locationManager.startUpdatingLocation()
//            if let loc = locationManager.location {
//                currLoc = loc
//                setupForm()
//            }
//        }
//    }
//
//    // MARK: - Private functions
//    private func setupForm() {
//        form +++ Section("Device Properties")
//             <<< TextRow() { row in
//                 row.tag = "NameRow"
//                 row.title = "Name"
//                 row.placeholder = "Enter Device Name"
//                 row.add(rule: RuleRequired())
//             }
//            <<< TextRow() { row in
//                row.tag = "ATVModelRow"
//                row.title = "Vehicle Model"
//                row.placeholder = "Enter Vehicle Model"
//                row.add(rule: RuleRequired())
//            }
//
//
//        form +++ Section("Geofence Settings")
//            <<< SwitchRow { row in
//                row.tag = "GFToggleRow"
//                row.title = "Enable Geofence?"
//                row.value = false
//            }
//            <<< IntRow() { row in
//                row.tag = "GFRadiusRow"
//                row.title = "Geofencing Radius"
//                row.placeholder = "Enter radius (meters) for geofence"
//                row.add(ruleSet: RuleSet<Int>())
//            }.onCellHighlightChanged({ (cell, row) in
//                if row.isHighlighted == false {
//                    if let val = self.form.rowBy(tag: "GFRadiusRow")?.baseValue   {
//                        self.gfRad = "\(val)"
//
//                    }
//                }
//            })
//            <<< LocationRow(){ row in
//                row.updateCell()
//                row.tag = "GFCenterRow"
//                row.title = "Geofencing Center"
//                row.value = currLoc
//                row.value2 = gfRad
//            }.onCellSelection({ (cell, row) in
//                row.value2 = self.gfRad
//            })
//
//
//
//             +++ Section("About")
//             <<< TextRow() { row in
//                 row.title = "Manufacturer"
//                 row.tag = "ManRow"
//                 row.value = manufacturer
//                 row.disabled = true
//             }.cellSetup { cell, row in
//                 cell.titleLabel?.textColor = .blue
//             }
//             <<< TextRow() { row in
//                 row.title = "Model Number"
//                 row.tag = "ModelRow"
//                 row.value = modelNumber
//                 row.disabled = true
//             }
//             <<< TextRow() { row in
//                 row.title = "Serial Number"
//                 row.tag = "SerialRow"
//                 row.value = serialNumber
//                 row.disabled = true
//             }
//             <<< TextRow() { row in
//                 row.title = "Firmware Version"
//                 row.tag = "FirmwareRow"
//                 row.value = firmwareVersion
//                 row.disabled = true
//             }
//            <<< TextRow() { row in
//                 row.title = "Hardware Version"
//                 row.tag = "HardwareRow"
//                 row.value = hardwareVersion
//                 row.disabled = true
//            }.cellUpdate { cell, row in
//                 if !row.isValid {
//                     cell.titleLabel?.textColor = .systemRed
//                 }
//             }
//    }
//    private func setupNavBar() {
//        self.navigationItem.title = "New Device"
//        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
//        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
//        self.navigationItem.rightBarButtonItem = doneButton
//        self.navigationItem.leftBarButtonItem = cancelButton
//    }
//
//    private func validateForm() -> Bool {
//         guard let nameRow: TextRow = form.rowBy(tag: "NameRow"), let vehicleRow: TextRow = form.rowBy(tag: "ATVModelRow")
//        else {
//            fatalError("Unexpectedly found nil unwrapping row")
//        }
//        if (nameRow.value == nil || !nameRow.isValid) {
//            print("This name is invalid")
//            return false
//        }
//        if (vehicleRow.value == nil || !vehicleRow.isValid) {
//            print("This email is invalid")
//            return false
//        }
//        return true
//    }
//    private func getDeviceInfo() -> Device {
//        guard let nameRow: TextRow = form.rowBy(tag: "NameRow"), let vehicleRow: TextRow = form.rowBy(tag: "ATVModelRow"), let geoToggle: SwitchRow = form.rowBy(tag: "GFToggleRow"), let geoRad: IntRow = form.rowBy(tag: "GFRadiusRow"), let geoCenter: LocationRow = form.rowBy(tag: "GFCenterRow")
//        else {
//            fatalError("Unexpectedly found nil unwrapping devive data")
//        }
//
//        var rad: Int = 0
//        if geoRad.value != nil {
//            rad = geoRad.value!
//        }
//        else {
//            rad = 0
//        }
//        let newDevice = Device(name: nameRow.value!, modelNumber: modelNumber, serialNumber: serialNumber, atvModel: vehicleRow.value!, manufacturer: manufacturer, hardwareVersion: hardwareVersion, firmwareVersion: firmwareVersion, uid: "", devId: "", rideHistory: RideHistory(), rides: [], gfT: geoToggle.value!, gfR: Double(rad), gfC: geoCenter.value!)
////        let newDevice = Device()
//        return newDevice
//    }
//
//    @objc private func didTapDone() {
//        print("USER TAPPED DONE")
//        if (!validateForm()) {
//            presentWillDeleteAlert(title: "Disconnect Device?", message: "Please fill out all information", actionTitle: "Disconnect") {
//                self.dismiss(animated: true, completion: nil)
//            }
//            return
//        }
//        thisDevice = getDeviceInfo()
//        print("success new device")
//
//        // save device to Firebase
//        self.addToDevice(device: thisDevice)
//        // TODO: Get userid here
//        let uid = "uid"
//
//        // write back info to pi
//        let tokens = thisDevice.name + "," + uid + "," + "\(thisDevice.gfCenter)" + "," + "\(thisDevice.gfRadius)"
//        let data = Data(tokens.utf8)
//
//        let ack = Data("ACK".utf8)
//        kaddPeripheral.writeValue(ack, for: kaddCharacteristic, type: .withResponse)
//
//        // pass the device object in unwind segue to show on the devices table/collection view
//
////        self.performSegue(withIdentifier: "UnwindToDevices", sender: self)
//    }
//    @objc private func didTapCancel() {
//        if (!validateForm()) {
//            presentWillDeleteAlert(title: "Disconnect Device?", message: "Please fill out all information", actionTitle: "Disconnect") {
//                self.dismiss(animated: true, completion: nil)
//            }
//            return
//        }
//        self.dismiss(animated: true, completion: nil)
//    }
//
//// MARK: - Navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    }
//
//
//// MARK: - STORING DEVICE OBJECT INTO FIREBASE
//    func addToDevice(device: Device) {
//        let currUID: String = Auth.auth().currentUser!.uid
//        let gfGeoPoint: GeoPoint = GeoPoint.init(latitude: device.gfCenter.coordinate.latitude, longitude: device.gfCenter.coordinate.longitude)
//        let ref = Firestore.firestore().collection("devices").document()
//        ref.setData([
//            "name" : device.name,
//            "modelNumber" : device.modelNumber,
//            "serialNumber" : device.serialNumber,
//            "atvModel" : device.atvModel,
//            "manufacturer" : device.manufacturer,
//            "hardwareVersion" : device.hardwareVersion,
//            "firmwareVersion" : device.firmwareVersion,
//            "lastLocation" : "",
//            "uid" : currUID,
//            "devId" : ref.documentID,
//            "rideHistory" : [],
//            "gfToggle" : device.gfToggle,
//            "gfRadius" : device.gfRadius,
//            "gfCenter" : gfGeoPoint
//        ]) { err in
//            if let err = err {
//                print("Error adding document: \(err)")
//            } else {
//                print("Document added with ID: \(ref.documentID)")
//                self.addToUserDevice(id: ref.documentID)
//
//
//
//                self.performSegue(withIdentifier: "UnwindToDevices", sender: self)
//
//            }
//        }
//
//    }
//
//    func addToUserDevice(id: String) {
//        if let uid = Auth.auth().currentUser?.uid {
//            let ref = db.collection("users").document(uid)
//            ref.updateData([
//                "Devices" : FieldValue.arrayUnion([id])
//            ]) {err in
//                if let err = err {
//                    print("Error adding document: \(err)")
//                } else {
//                    print("Successfully updated users.device: \(ref.documentID)")
//                }
//            }
//        }
//    }
//}
//
//
//
//
//
//
//
//
//
//
////MARK: LocationRow
//public final class LocationRow: OptionsRow<PushSelectorCell<CLLocation>>, PresenterRowType, RowType {
//
//    public typealias PresenterRow = MapViewController
//
//    /// Defines how the view controller will be presented, pushed, etc.
//    public var presentationMode: PresentationMode<PresenterRow>?
//
//    /// Will be called before the presentation occurs.
//    public var onPresentCallback: ((FormViewController, PresenterRow) -> Void)?
//
//    public required init(tag: String?) {
//        super.init(tag: tag)
//        presentationMode = .show(controllerProvider: ControllerProvider.callback { return MapViewController(){ _ in } }, onDismiss: { vc in _ = vc.navigationController?.popViewController(animated: true) })
//
//        displayValueFor = {
//            guard let location = $0 else { return "" }
//            let fmt = NumberFormatter()
//            fmt.maximumFractionDigits = 4
//            fmt.minimumFractionDigits = 4
//            let latitude = fmt.string(from: NSNumber(value: location.coordinate.latitude))!
//            let longitude = fmt.string(from: NSNumber(value: location.coordinate.longitude))!
//            return  "\(latitude), \(longitude)"
//        }
//    }
//
//    /**
//     Extends `didSelect` method
//     */
//    public override func customDidSelect() {
//        super.customDidSelect()
//        guard let presentationMode = presentationMode, !isDisabled else { return }
//        if let controller = presentationMode.makeController() {
//            controller.row = self
//            controller.title = selectorTitle ?? controller.title
//            onPresentCallback?(cell.formViewController()!, controller)
//            presentationMode.present(controller, row: self, presentingController: self.cell.formViewController()!)
//        } else {
//            presentationMode.present(nil, row: self, presentingController: self.cell.formViewController()!)
//        }
//    }
//
//    /**
//     Prepares the pushed row setting its title and completion callback.
//     */
//    public override func prepare(for segue: UIStoryboardSegue) {
//        super.prepare(for: segue)
//        guard let rowVC = segue.destination as? PresenterRow else { return }
//        rowVC.title = selectorTitle ?? rowVC.title
//        rowVC.onDismissCallback = presentationMode?.onDismissCallback ?? rowVC.onDismissCallback
//        onPresentCallback?(cell.formViewController()!, rowVC)
//        rowVC.row = self
//    }
//}
//
//public class MapViewController : UIViewController, TypedRowControllerType, MKMapViewDelegate {
//
//    public var row: RowOf<CLLocation>!
//    public var onDismissCallback: ((UIViewController) -> ())?
//
//
//    lazy var mapView : MKMapView = { [unowned self] in
//        let v = MKMapView(frame: self.view.bounds)
//        v.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        return v
//        }()
//
//    lazy var pinView: UIImageView = { [unowned self] in
//        let v = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
////        v.image = UIImage(named: "map_pin", in: Bundle(for: MapViewController.self), compatibleWith: nil)
////        v.image = UIImage(named: "mappin")
//        v.image = UIImage(systemName: "mappin")
//
//        v.image = v.image?.withRenderingMode(.alwaysTemplate)
//        v.tintColor = self.view.tintColor
//        v.backgroundColor = .clear
//        v.clipsToBounds = true
//        v.contentMode = .scaleAspectFit
//        v.isUserInteractionEnabled = false
//        return v
//        }()
//
//
//    var width: CGFloat = 0
//    var height: CGFloat = 0
//
//    lazy var ellipse: UIBezierPath = { [unowned self] in
//        let ellipse = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: self.width, height: self.height))
//        return ellipse
//        }()
//
//
//    lazy var ellipsisLayer: CAShapeLayer = { [unowned self] in
//        let layer = CAShapeLayer()
//
//        if let rad = row.value2, let formatRad = Double(rad) {
//            self.width = CGFloat(formatRad)
//            self.height = CGFloat(formatRad)
//        }
//
//        layer.bounds = CGRect(x: 0, y: 0, width: self.width, height: self.height)
//        layer.path = self.ellipse.cgPath
//        layer.fillColor = UIColor.clear.cgColor
//        layer.fillRule = .nonZero
//        layer.lineCap = .butt
//        layer.lineDashPattern = nil
//        layer.lineDashPhase = 0.0
//        layer.lineJoin = .miter
//        layer.lineWidth = 1.0
//        layer.miterLimit = 10.0
//        layer.strokeColor = UIColor.red.cgColor
//        return layer
//        }()
//
//
//    required public init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//
//    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    convenience public init(_ callback: ((UIViewController) -> ())?){
//        self.init(nibName: nil, bundle: nil)
//        onDismissCallback = callback
//    }
//
//    public override func viewDidLoad() {
//        super.viewDidLoad()
//        view.addSubview(mapView)
//
//        mapView.delegate = self
//        mapView.addSubview(pinView)
//        mapView.layer.insertSublayer(ellipsisLayer, below: pinView.layer)
//
//        let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(MapViewController.tappedDone(_:)))
//        button.title = "Done"
//        navigationItem.rightBarButtonItem = button
//
//        if let value = row.value {
//            let region = MKCoordinateRegion(center: value.coordinate, latitudinalMeters: 400, longitudinalMeters: 400)
//            mapView.setRegion(region, animated: true)
//        }
//        else{
//            mapView.showsUserLocation = true
//        }
//        updateTitle()
//
//    }
//
//    public override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        let center = mapView.convert(mapView.centerCoordinate, toPointTo: pinView)
//        pinView.center = CGPoint(x: center.x, y: center.y - (pinView.bounds.height/2))
//        ellipsisLayer.position = center
//    }
//
//
//    @objc func tappedDone(_ sender: UIBarButtonItem){
//        let target = mapView.convert(ellipsisLayer.position, toCoordinateFrom: mapView)
//        row.value = CLLocation(latitude: target.latitude, longitude: target.longitude)
//        onDismissCallback?(self)
//    }
//
//    func updateTitle(){
//        let fmt = NumberFormatter()
//        fmt.maximumFractionDigits = 4
//        fmt.minimumFractionDigits = 4
//        let latitude = fmt.string(from: NSNumber(value: mapView.centerCoordinate.latitude))!
//        let longitude = fmt.string(from: NSNumber(value: mapView.centerCoordinate.longitude))!
//        title = "\(latitude), \(longitude)"
//    }
//
//    public func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
//        ellipsisLayer.transform = CATransform3DMakeScale(0.5, 0.5, 1)
//        UIView.animate(withDuration: 0.2, animations: { [weak self] in
//            self?.pinView.center = CGPoint(x: self!.pinView.center.x, y: self!.pinView.center.y - 10)
//            })
//    }
//
//    public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        ellipsisLayer.transform = CATransform3DIdentity
//        UIView.animate(withDuration: 0.2, animations: { [weak self] in
//            self?.pinView.center = CGPoint(x: self!.pinView.center.x, y: self!.pinView.center.y + 10)
//            })
//        updateTitle()
//    }
//}
//
//public final class ImageCheckRow<T: Equatable>: Row<ImageCheckCell<T>>, SelectableRowType, RowType {
//    public var selectableValue: T?
//    required public init(tag: String?) {
//        super.init(tag: tag)
//        displayValueFor = nil
//    }
//}
//
//public class ImageCheckCell<T: Equatable> : Cell<T>, CellType {
//
//    required public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//    }
//
//    required public init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    /// Image for selected state
//    lazy public var trueImage: UIImage = {
//        return UIImage(named: "selected")!
//    }()
//
//    /// Image for unselected state
//    lazy public var falseImage: UIImage = {
//        return UIImage(named: "unselected")!
//    }()
//
//    public override func update() {
//        super.update()
//        checkImageView?.image = row.value != nil ? trueImage : falseImage
//        checkImageView?.sizeToFit()
//    }
//
//    /// Image view to render images. If `accessoryType` is set to `checkmark`
//    /// will create a new `UIImageView` and set it as `accessoryView`.
//    /// Otherwise returns `self.imageView`.
//    open var checkImageView: UIImageView? {
//        guard accessoryType == .checkmark else {
//            return self.imageView
//        }
//
//        guard let accessoryView = accessoryView else {
//            let imageView = UIImageView()
//            self.accessoryView = imageView
//            return imageView
//        }
//
//        return accessoryView as? UIImageView
//    }
//
//    public override func setup() {
//        super.setup()
//        accessoryType = .none
//    }
//
//    public override func didSelect() {
//        row.reload()
//        row.select()
//        row.deselect()
//    }
//
//}
