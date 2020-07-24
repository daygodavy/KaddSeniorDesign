//
//  ManageDevicesViewController.swift
//  AgriGuardian
//
//  Created by Daniel Weatrowski on 4/21/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
// Summary: For users to manage their devices (Edit or Delete)
// TODO: Load all devices. Segue to Device detail with isNew = false upon selection and send selected device
// to device detail - vc.thisDevice = devices[indexPath.row]
import UIKit
import CoreBluetooth


class ManageDevicesViewController: UITableViewController, RefreshDataDelegate {
    
    // MARK: - Properties
    let fbManager: FirebaseManager = FirebaseManager()
    var user: User = User()
    var devices: [Device] = []
    var spinner: UIActivityIndicatorView = UIActivityIndicatorView()
    var centralManager: CBCentralManager!
    var kaddService: CBUUID = CBUUID(string: "27cf08c1-076a-41af-becd-02ed6f6109b9")
    var kaddInitCharacteristic = CBUUID(string: "c37ce97e-40cb-4875-9886-df66323f6e4c")
    var kaddInitPeripheral: CBPeripheral!
    var kaddCharactaristic: CBCharacteristic!
    
    var deviceModelNumber = ""
    var deviceSerialNumber = ""
    var deviceManufacturer = ""
    
    var enableBluetooth = true

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        self.navigationItem.rightBarButtonItem = addButton
        self.refreshData()
        centralManager = CBCentralManager(delegate: self, queue: nil)

    }

    // MARK: - Actions
    @objc private func didTapAdd() {
        
        if (enableBluetooth) {
            print("11111111111111111111111")
            centralManager.scanForPeripherals(withServices: [kaddService])
            print("22222222222222222222222")
        }
        else {
            print("33333333333333333333333")
            self.segueToDeviceDetailVC(isNewDev: true, thisDev: Device())
            print("44444444444444444444444")
        }
        print("55555555555555555555555")

    }
    
    func startSpinner() {
        self.spinner.center = self.view.center
        self.spinner.style = .large
        self.spinner.startAnimating()
        self.view.addSubview(spinner)
    }
    
    func loadData() {
        fbManager.loadUserProfile { (user) in
            self.user = user
            //            self.currDevice = self.loadCurrentDevice()
            self.devices = user.getDevices()
            self.devices += DataManager().loadDevs()
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.reloadData()
            self.spinner.stopAnimating()
        }
    }
    
    func refreshData() {
        self.startSpinner()
        self.loadData()
    }
    
    func segueToDeviceDetailVC(isNewDev: Bool, thisDev: Device) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(identifier: "DeviceDetail") as! DeviceDetailViewController

        if isNewDev {
            vc.title = "New Device"
            vc.modelNumber = deviceModelNumber
            vc.serialNumber = deviceSerialNumber
            vc.kaddPeripheral = kaddInitPeripheral
            vc.kaddCharacteristic = kaddCharactaristic
            vc.enableBluetooth = self.enableBluetooth
        }
        else {
            vc.title = "Edit Device"
//            vc.deviceNameLabel.text = thisDev.name
//            vc.vehicleModelLabel.text = thisDev.atvModel
//            vc.geofenceToggle.isOn = thisDev.gfToggle
//            vc.geofenceRadius.text = String(thisDev.gfRadius)
//            vc.gfCenter = thisDev.gfCenter
        }
        
        vc.thisDevice = thisDev
        vc.isNew = isNewDev
        vc.viewDelegate = self
        //navController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
        //self.present(navController, animated: true)
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.devices.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManageDeviceTableViewCell", for: indexPath) as! ManageDeviceTableViewCell

        // Configure the cell...
        cell.backgroundColor = .systemGray5
        cell.nameLabel.text = self.devices[indexPath.row].getDeviceName()
        cell.vehicleLabel.text = self.devices[indexPath.row].getVehicleName()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row \(indexPath.item) was pressed")
        self.segueToDeviceDetailVC(isNewDev: false, thisDev: self.devices[indexPath.item])
    }

}

class ManageDeviceTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var vehicleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
extension ManageDevicesViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        func centralManagerDidUpdateState(_ central: CBCentralManager) {
            switch central.state {
              case .unknown:
                print("central.state is .unknown")
              case .resetting:
                print("central.state is .resetting")
              case .unsupported:
                print("central.state is .unsupported")
              case .unauthorized:
                print("central.state is .unauthorized")
              case .poweredOff:
                print("central.state is .poweredOff")
              case .poweredOn:
                print("central.state is .poweredOn")
            @unknown default:
                fatalError("Unknown Peripheral State")
            }
        }
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any], rssi RSSI: NSNumber) {
        self.spinner.stopAnimating()
        kaddInitPeripheral = peripheral
        kaddInitPeripheral.delegate = self
        centralManager.stopScan()
        presentBasicAlert(title: "New Device Found", message: "Connect to this device?") {
            self.centralManager.connect(self.kaddInitPeripheral, options: nil)
        }

        
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected Bitch!")
        kaddInitPeripheral.discoverServices(nil)
    }
    
    
}
extension ManageDevicesViewController: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else {
            fatalError("Unable to unwrap services")
        }
        for service in services {
          print(service)
          peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        guard let characteristics = service.characteristics else {
            fatalError("Unexpectedly found nil while unwrapping characteristics")
        }

        for characteristic in characteristics {
            if (characteristic.uuid == kaddInitCharacteristic) {
                print(characteristic)
                if characteristic.properties.contains(.read) {
                    print("\(characteristic.uuid): properties contains .read")
                    peripheral.readValue(for: characteristic)
                }
                if characteristic.properties.contains(.notify) {
                  print("\(characteristic.uuid): properties contains .notify")
                }
                if characteristic.properties.contains(.write) {
                  print("\(characteristic.uuid): properties contains .write")
                }
            }
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if (characteristic.uuid == kaddInitCharacteristic) {
            // read data
            self.kaddCharactaristic = characteristic
            guard let data = characteristic.value else {
                fatalError("Unexpectedly foundn nil when unwrapping characteristic value for initial setup")
            }
            let dataAsString = String(decoding: data, as: UTF8.self)
            let tokens = dataAsString.components(separatedBy: ",")
            
            deviceModelNumber = tokens[0]
            deviceSerialNumber = tokens[1]
            deviceManufacturer = tokens[2]
            
            print("Will Segue Here")
            self.segueToDeviceDetailVC(isNewDev: true, thisDev: Device())

            // TODO: Pass Model and Serial number through segue and add to device info
            
//            print("success")
//            print("Writing to peripheral")
//            let ack = Data("ACK".utf8)
//            peripheral.writeValue(ack, for: characteristic, type: .withResponse)
        }
    }
}
