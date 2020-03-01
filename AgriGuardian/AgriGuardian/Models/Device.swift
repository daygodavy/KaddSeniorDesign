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
    
    init() {
        name = ""
        modelNumber = ""
        serialNumber = ""
        atvModel = ""
        manufacturer = ""
        hardwareVersion = ""
        firmwareVersion = ""
    }
    
    
    init(name: String, modelNumber: String, serialNumber: String, atvModel: String, manufacturer: String, hardwareVersion: String, firmwareVersion: String) {
        self.name = name
        self.modelNumber = modelNumber
        self.serialNumber = serialNumber
        self.atvModel = atvModel
        self.manufacturer = manufacturer
        self.hardwareVersion = hardwareVersion
        self.firmwareVersion = firmwareVersion
    }
    
}


