//
//  AddDeviceTableViewController.swift
//  AgriGuardian
//
//  Created by Daniel Weatrowski on 2/25/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit
import Eureka

class AddDeviceViewController: FormViewController {
    
    // MARK: - Properties
    var thisDevice = Device()
    let hardwareVersion = "1.0.0"
    let firmwareVersion = "1.0.0"
    let modelNumber = "A1"
    let serialNumber = "AAKS776WJW8P00"
    let manufacturer = "Kadd Inc."

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupForm()
        self.title = "Add Device"
    }

    // MARK: - Private functions
    private func setupForm() {
        form +++ Section("Device Properties")
             <<< TextRow() { row in
                 row.tag = "NameRow"
                 row.title = "Name"
                 row.placeholder = "Enter Device Name"
                 row.add(rule: RuleRequired())
             }
            <<< TextRow() { row in
                row.tag = "ATVModelRow"
                row.title = "Vehicle Model"
                row.placeholder = "Enter Vehicle Model"
                row.add(rule: RuleRequired())
            }
             +++ Section("About")
             <<< TextRow() { row in
                 row.title = "Manufacturer"
                 row.tag = "ManRow"
                 row.value = manufacturer
                 row.disabled = true
             }.cellSetup { cell, row in
                 cell.titleLabel?.textColor = .blue
             }
             <<< TextRow() { row in
                 row.title = "Model Number"
                 row.tag = "ModelRow"
                 row.value = modelNumber
                 row.disabled = true
             }
             <<< TextRow() { row in
                 row.title = "Serial Number"
                 row.tag = "SerialRow"
                 row.value = serialNumber
                 row.disabled = true
             }
             <<< TextRow() { row in
                 row.title = "Firmware Version"
                 row.tag = "FirmwareRow"
                 row.value = firmwareVersion
                 row.disabled = true
             }
            <<< TextRow() { row in
                 row.title = "Hardware Version"
                 row.tag = "HardwareRow"
                 row.value = hardwareVersion
                 row.disabled = true
            }.cellUpdate { cell, row in
                 if !row.isValid {
                     cell.titleLabel?.textColor = .systemRed
                 }
             }
    }
    private func setupNavBar() {
        self.navigationItem.title = "New Device"
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
        self.navigationItem.rightBarButtonItem = doneButton
        self.navigationItem.leftBarButtonItem = cancelButton
    }
    
    private func validateForm() -> Bool {
         guard let nameRow: TextRow = form.rowBy(tag: "NameRow"), let vehicleRow: TextRow = form.rowBy(tag: "ATVModelRow")
        else {
            fatalError("Unexpectedly found nil unwrapping row")
        }
        if (nameRow.value == nil || !nameRow.isValid) {
            print("This name is invalid")
            return false
        }
        if (vehicleRow.value == nil || !vehicleRow.isValid) {
            print("This email is invalid")
            return false
        }
        return true
    }
    private func getDeviceInfo() -> Device {
        guard let nameRow: TextRow = form.rowBy(tag: "NameRow"), let vehicleRow: TextRow = form.rowBy(tag: "ATVModelRow")
        else {
            fatalError("Unexpectedly found nil unwrapping devive data")
        }
        let newDevice = Device(name: nameRow.value!, modelNumber: modelNumber, serialNumber: serialNumber, atvModel: vehicleRow.value!, manufacturer: manufacturer, hardwareVersion: hardwareVersion, firmwareVersion: firmwareVersion)
        return newDevice
    }
    
    @objc private func didTapDone() {
        print("USER TAPPED DONE")
        if (!validateForm()) {
            presentWillDeleteAlert(title: "Disconnect Device?", message: "Please fill out all information", actionTitle: "Disconnect") {
                self.dismiss(animated: true, completion: nil)
            }
            return
        }
        thisDevice = getDeviceInfo()
        print("success new device")
        self.performSegue(withIdentifier: "unwindToDevices", sender: self)
    }
    @objc private func didTapCancel() {
        if (!validateForm()) {
            presentWillDeleteAlert(title: "Disconnect Device?", message: "Please fill out all information", actionTitle: "Disconnect") {
                self.dismiss(animated: true, completion: nil)
            }
            return
        }
        self.dismiss(animated: true, completion: nil)
    }

// MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
    }
    
}
