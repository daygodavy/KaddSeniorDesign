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
    var tripHistory: [Ride]
    var devices: [Device]
    
    init() {
        self.firstName = ""
        self.lastName = ""
        self.phoneNumber = ""
        self.emailAddress = ""
        self.uid = ""
        self.tripHistory = [Ride]()
        self.devices = [Device]()
    }
    
    init(firstName: String, lastName: String, phoneNumber: String, uid: String, emailAddress: String, devices: [Device], rides: [Ride]) {
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.emailAddress = emailAddress
        self.uid = uid
        self.devices = devices
        self.tripHistory = rides
        
    }
}
