//
//  AddDeviceTableViewController.swift
//  AgriGuardian
//
//  Created by Daniel Weatrowski on 2/24/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit
import CoreBluetooth

class DeviceTableViewController: UITableViewController {
    
    // MARK: - Properties
    var devices: [Device] = [Device]()
    // TODO: Implement QR View Controller
    var kaddService: CBUUID = CBUUID(string: "27cf08c1-076a-41af-becd-02ed6f6109b9")
    var kaddInitCharacteristic = CBUUID(string: "c37ce97e-40cb-4875-9886-df66323f6e4c")
    var kaddInitPeripheral: CBPeripheral!
    var spinner = UIActivityIndicatorView(style: .large)
    var centralManager: CBCentralManager!



    // MARK: - View Controls
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Devices"
        setupNavBar()
        centralManager = CBCentralManager(delegate: self, queue: nil)

    }
    // MARK: - Private functions
    private func setupNavBar() {
        self.navigationItem.title = "Devices"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didSelectAddDevice))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func didSelectAddDevice() {
        
        self.spinner.center = self.view.center
        self.spinner.hidesWhenStopped = true
        self.spinner.startAnimating()
        self.view.addSubview(spinner)
        //centralManager.scanForPeripherals(withServices: [kaddService])
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(identifier: "AddDevice")
        self.navigationController?.pushViewController(vc, animated: true)

        

    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return devices.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel!.text = devices[indexPath.row].name
        

        return cell
    }
//    
//    // MARK: - Navigation
//    @IBAction func unwindFromAddDevice(unwindSegue: UIStoryboardSegue) {
//        if unwindSegue.source is AddDeviceViewController {
//            if let sourceVC = unwindSegue.source as? AddDeviceViewController {
//                devices.append(sourceVC.thisDevice)
//            }
//            tableView.reloadData()
//        }
//    }
}
extension DeviceTableViewController: CBCentralManagerDelegate {
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
                //centralManager.scanForPeripherals(withServices: [kaddService])

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
extension DeviceTableViewController: CBPeripheralDelegate {
    
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
            print("Writing to peripheral")
            let ack = Data("ACK".utf8)
            peripheral.writeValue(ack, for: characteristic, type: .withResponse)
        }
    }
    
    
}
