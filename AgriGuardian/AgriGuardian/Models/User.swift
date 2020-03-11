//
//  User.swift
//  AgriGuardian
//
//  Created by Daniel Weatrowski on 2/29/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import Foundation

public final class User {
    var firstName: String
    var lastName: String
    var phoneNumber: String
    var emailAddress: String
    var uid: String
    var devices: [Device]
    var currentDevice: Device
    
    init() {
        self.firstName = ""
        self.lastName = ""
        self.phoneNumber = ""
        self.emailAddress = ""
        self.uid = ""
        self.devices = [Device]()
        self.currentDevice = Device()
    }
    
    init(firstName: String, lastName: String, phoneNumber: String, uid: String, emailAddress: String, devices: [Device], currentDevice: Device) {
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.emailAddress = emailAddress
        self.uid = uid
        self.devices = devices
        self.currentDevice = currentDevice
    }
    
    func getDevices() -> [Device] {
        return self.devices
    }
    func setCurrentDevice(withDevice: Device) {
        self.currentDevice = withDevice
    }
}
