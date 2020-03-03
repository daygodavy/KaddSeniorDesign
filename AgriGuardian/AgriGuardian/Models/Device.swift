//
//  Device.swift
//  AgriGuardian
//
//  Created by Daniel Weatrowski on 2/25/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import Foundation

class Device {
    var name: String
    var modelNumber: String
    var serialNumber: String
    var atvModel: String
    var manufacturer: String
    var firmwareVersion: String
    var hardwareVersion: String
    var uid: String
    
    init() {
        name = ""
        modelNumber = ""
        serialNumber = ""
        atvModel = ""
        manufacturer = ""
        hardwareVersion = ""
        firmwareVersion = ""
        uid = ""
    }
    
    
    init(name: String, modelNumber: String, serialNumber: String, atvModel: String, manufacturer: String, hardwareVersion: String, firmwareVersion: String, uid: String) {
        self.name = name
        self.modelNumber = modelNumber
        self.serialNumber = serialNumber
        self.atvModel = atvModel
        self.manufacturer = manufacturer
        self.hardwareVersion = hardwareVersion
        self.firmwareVersion = firmwareVersion
        self.uid = uid
    }
    
    // Reading data into from Firebase
    init(data: [String: Any]) {
        self.name = data["name"] as! String
        self.modelNumber = data["modelNumber"] as! String
        self.serialNumber = data["serialNumber"] as! String
        self.atvModel = data["atvModel"] as! String
        self.manufacturer = data["manufacturer"] as! String
        self.hardwareVersion = data["hardwareVersion"] as! String
        self.firmwareVersion = data["firmwareVersion"] as! String
        self.uid = data["uid"] as! String
    }
    
    func printDevice() {
        print("====================")
        print("name: \(self.name)")
        print("====================")
    }
    
}


