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
    var lastLocation: String
    var uid: String
    var devId: String
    var rideHistory: RideHistory
    
    init() {
        name = ""
        modelNumber = ""
        serialNumber = ""
        atvModel = ""
        manufacturer = ""
        hardwareVersion = ""
        firmwareVersion = ""
        uid = ""
        devId = ""
        lastLocation = ""
        rideHistory = RideHistory()
        
    }
    
    
    init(name: String, modelNumber: String, serialNumber: String, atvModel: String, manufacturer: String, hardwareVersion: String, firmwareVersion: String, uid: String, devId: String, rideHistory: RideHistory) {
        self.name = name
        self.modelNumber = modelNumber
        self.serialNumber = serialNumber
        self.atvModel = atvModel
        self.manufacturer = manufacturer
        self.hardwareVersion = hardwareVersion
        self.firmwareVersion = firmwareVersion
        self.uid = uid
        self.devId = devId
        // fix later
        self.lastLocation = ""
        self.rideHistory = rideHistory
    }
    
//    // Reading data into from Firebase
//    init(data: [String: Any]) {
//        self.name = data["name"] as! String
//        self.modelNumber = data["modelNumber"] as! String
//        self.serialNumber = data["serialNumber"] as! String
//        self.atvModel = data["atvModel"] as! String
//        self.manufacturer = data["manufacturer"] as! String
//        self.hardwareVersion = data["hardwareVersion"] as! String
//        self.firmwareVersion = data["firmwareVersion"] as! String
//        self.uid = data["uid"] as! String
//        self.devId = data["devId"] as! String
//        // TODO: - Davy Add Last Location
//        self.lastLocation = ""
//    }
    
    func getDeviceName() -> String {
        return self.name
    }
    func getVehicleName() -> String {
        return self.atvModel
    }
    
    func printDevice() {
        print("====================")
        print("name: \(self.name)")
        print("====================")
    }
    func updateLocation(location: String) {
        self.lastLocation = location
    }
    
}


