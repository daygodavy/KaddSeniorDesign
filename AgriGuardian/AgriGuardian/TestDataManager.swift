//
//  TestDataManager.swift
//  
//
//  Created by Daniel Weatrowski on 3/8/20.
//

import Foundation
import UIKit

class DataManager {
    
    func loadSampleData() -> User {
        return loadUser()
    }

    func loadUser() -> User {
        let devices = loadDevices()
        let user = User(firstName: "Johnny", lastName: "Farmer", phoneNumber: "7147824460", uid: "u0001", emailAddress: "jfarmer@kadd.com", devices: devices, rides: [Ride]())
        
        return user
    }
     func loadDevices() -> [Device] {
        var device1 = Device(name: "iKadd Device", modelNumber: "A1", serialNumber: "A16DB9663", atvModel: "FOURTRAX RECON 4x4", manufacturer: "Honda", hardwareVersion: "1.0.0", firmwareVersion: "1.1.0", uid: "u0001", devId: "d0001")
        var device2 = Device(name: "Rincon Kadd", modelNumber: "A2", serialNumber: "A26DB9663", atvModel: "FOURTRAX RINCON", manufacturer: "Honda", hardwareVersion: "1.1.0", firmwareVersion: "1.0.0", uid: "u0001", devId: "d0010")
        var device3 = Device(name: "Griz-ly", modelNumber: "A3", serialNumber: "A36DB9663", atvModel: "Grizzly EPS XT-R", manufacturer: "Yamaha", hardwareVersion: "1.0.0", firmwareVersion: "1.1.0", uid: "u0101", devId: "d0101")
        var device4 = Device(name: "King Kadd", modelNumber: "A4", serialNumber: "A46DB9663", atvModel: "KingQuad 750AXi Camo", manufacturer: "Suzuki", hardwareVersion: "1.0.0", firmwareVersion: "1.0.0", uid: "u1000", devId: "d1000")
        
        let testDevices = [device1, device2, device3, device4]
        return testDevices
        
    }
     func loadRides() {
        
    }
}
