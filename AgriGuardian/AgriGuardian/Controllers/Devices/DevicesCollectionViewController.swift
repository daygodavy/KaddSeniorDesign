//
//  DevicesCollectionViewController.swift
//  AgriGuardian
//
//  Created by Daniel Weatrowski on 3/3/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit
import CoreBluetooth


private let reuseIdentifier = "Cell"
private let deviceIdentifier = "DeviceCell"

class DevicesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    fileprivate let spacing: CGFloat = 16.0
    fileprivate var count = [1]
    var dataManager = DataManager()
    var fbManager = FirebaseManager()
    var user = User()
    var devices = [Device]()
    var activityView = UIActivityIndicatorView()
    var kaddService: CBUUID = CBUUID(string: "27cf08c1-076a-41af-becd-02ed6f6109b9")
    var kaddInitCharacteristic = CBUUID(string: "c37ce97e-40cb-4875-9886-df66323f6e4c")
    var kaddInitPeripheral: CBPeripheral!
    var kaddCharactaristic: CBCharacteristic!
    var spinner = UIActivityIndicatorView(style: .large)
    var centralManager: CBCentralManager!
    
    var deviceModelNumber = ""
    var deviceSerialNumber = ""

    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showActivityIndicator()
        setupNavBar()
        registerFlowLayout()
        collectionView.dataSource = self
        
        centralManager = CBCentralManager(delegate: self, queue: nil)

        
        
        // LOAD DATA FROM FIREBASE HERE
        
//        user = dataManager.loadSampleData()
//        dataManager.loadDevices_tempUser { (user) in
//            self.user = user
////            self.currDevice = self.loadCurrentDevice()
//            self.devices = user.getDevices()
//            self.collectionView.dataSource = self
//            self.collectionView.delegate = self
//            self.collectionView.reloadData()
////            self.activityView.stopAnimating()
//        }
//        devices = user.getDevices()
        print("1")
        self.loadData()
        print("2")
        
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        let nib = UINib(nibName: "DeviceCollectionViewCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: deviceIdentifier)

        // Do any additional setup after loading the view.
        self.collectionView.reloadData()
    }
    
    func loadData() {
        fbManager.loadUserProfile { (user) in
            self.user = user
            print("user NAME: \(self.user.firstName)")
            //            self.currDevice = self.loadCurrentDevice()
            self.devices = user.getDevices()
            self.collectionView.dataSource = self
            self.collectionView.delegate = self
            self.collectionView.reloadData()
            self.activityView.stopAnimating()
        }
    }
    
    func showActivityIndicator() {
        self.activityView.style = .large
        activityView.center = self.view.center
        self.view.addSubview(activityView)
        activityView.startAnimating()
    }
    
    
    // MARK: - Private functions
    fileprivate func registerFlowLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.collectionView.collectionViewLayout = layout
    }
    private func setupNavBar() {
        self.navigationItem.title = "Devices"

        let manageButton = UIBarButtonItem(title: "Manage", style: .plain, target: self, action: #selector(didTapManage))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeMenu))
        self.navigationItem.rightBarButtonItem = manageButton
        self.navigationItem.leftBarButtonItem = cancelButton
    }
    private func navigateToDashboard(withDeviceAt index: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let MainTabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
        MainTabBarController.chosenDevice = devices[index]
        MainTabBarController.modalPresentationStyle = .fullScreen
        self.present(MainTabBarController, animated: true, completion: nil)
    }
    private func navigateToAddDevice() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(identifier: "AddDevice") as! AddDeviceViewController
        // send over serial and model numbers + peripheral so that it can write back to pi
        vc.modelNumber = self.deviceModelNumber
        vc.serialNumber = self.deviceSerialNumber
        vc.kaddPeripheral = self.kaddInitPeripheral
        vc.kaddCharacteristic = self.kaddCharactaristic
        
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated: true)
    }
    
    @objc private func closeMenu() {
        self.dismiss(animated: true, completion: nil)
        // TODO: Disconnect device if connected
    }
    @objc private func didTapManage() {
        // TODO: Segue to device manager
        if let tabBarController = self.presentingViewController as? UITabBarController {
            self.dismiss(animated: true) {
                tabBarController.selectedIndex = 2
                // TODO: Push Manage Devices view
                
            }
        }
//        self.spinner.center = self.view.center
//        self.spinner.hidesWhenStopped = true
//        self.spinner.startAnimating()
//        self.view.addSubview(spinner)
//        centralManager.scanForPeripherals(withServices: [kaddService])
    }


    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return devices.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: deviceIdentifier, for: indexPath) as! DeviceCollectionViewCell
        
        cell.backgroundColor = .systemGray5
        cell.nameLabel.text = devices[indexPath.row].getDeviceName()
        cell.vehicleLabel.text = devices[indexPath.row].getVehicleName()
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 2 * spacing, height: 80)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        user.setCurrentDevice(withDevice: devices[indexPath.row])
        fbManager.setCurrDevice(currDev: devices[indexPath.row].devId)
        navigateToDashboard(withDeviceAt: indexPath.row)
    }

    
    // MARK: - Navigation
    @IBAction func unwindFromAddDevice(unwindSegue: UIStoryboardSegue) {
        if unwindSegue.source is AddDeviceViewController {
            if let sourceVC = unwindSegue.source as? AddDeviceViewController {
                count.append(1)
            }
//            self.loadData()
//            collectionView.reloadData()
        }
        self.showActivityIndicator()
        self.loadData()
    }

}

extension DevicesCollectionViewController: CBCentralManagerDelegate {
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
extension DevicesCollectionViewController: CBPeripheralDelegate {
    
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
            navigateToAddDevice()
            
            // TODO: Pass Model and Serial number through segue and add to device info
            
//            print("success")
//            print("Writing to peripheral")
//            let ack = Data("ACK".utf8)
//            peripheral.writeValue(ack, for: characteristic, type: .withResponse)
        }
    }
    
    
}
