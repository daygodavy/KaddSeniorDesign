//
//  RideParameters.swift
//  AgriGuardian
//
//  Created by Davy Chuon on 2/26/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import Foundation

class RideParameters {
    
    /*
    // MARK: - IMU parameters

    */
    // Should axis data be float? Or String?
    var xAxis: String
    var yAxis: String
    var zAxis: String
    
    var rollover: Bool
    var timestamp: String
    
    /*
    // MARK: - GPS parameters

     210220,0.06,11,224020.000,38d,32',52.224",N,121d,47',9.402",W
     date, km, satellite connection count, UTC time, hour(d), minute('), second("), North, our(d), minute('), second("), West
     21/Feb/eb/2020/km/h,satellite connection count,time in UTC(22:40:20),coordinate
     xxdxx’xx” is like d is hour ' is minute ” is  is second. Its standard notation for coordinates and N,W  being north and west
    */
    var date: String
    var velocity: String // in km
    var satConnectCount: String
    var timestampUTC: String
    var northCoords: [[String]]
    var westCoords: [[String]]
    
    /*
    // MARK: - GPS parameters
     date,time,lat,long,km/h,satellites
     2020/02/26,22:44:00,38.56017,-121.7777,0.38892,9
    */
//    var adaDate: String
//    var adaTime: String
//    var adaLat: String
//    var adaLong: String
//    var adaKmPerH: String
//    var satelliteCount: String
    
    
    /*
    // MARK: - Default Constructor
    */
    init() {
        self.xAxis = ""
        self.yAxis = ""
        self.zAxis = ""
        self.rollover = false
        self.timestamp = ""
        self.date = ""
        self.velocity = ""
        self.satConnectCount = ""
        self.timestampUTC = ""
        self.northCoords = [[]]
        self.westCoords = [[]]
    }
    
    /*
    // MARK: - Custom Constructor

    */
    init(x: String, y: String, z: String, rollover: Bool, time: String, date: String, speed: String, satCount: String, UTC: String, north: [[String]], west: [[String]]) {
        self.xAxis = x
        self.yAxis = y
        self.zAxis = z
        self.rollover = rollover
        self.timestamp = time
        self.date = ""
        self.velocity = ""
        self.satConnectCount = ""
        self.timestampUTC = ""
        self.northCoords = [[]]
        self.westCoords = [[]]
    }
    
    
    
//    // Parsing
//    init(data: [String: Any]) {
//        if let res = data["orderHistory"] as? [String] {
//            self.orderHistory = res
//        } else {
//            self.orderHistory = []
//        }
//        self.uid = data["uid"] as! String
//        self.name = data["name"] as! String
//        self.email = data["email"] as! String
//    }
//
//    func printOrder() {
//        print("=======================")
//        print("uid: \(self.uid)")
//        print("name: \(self.name)")
//        print("email: \(self.email)")
//        print("orderHistory: \(self.orderHistory)")
//        print("=======================")
//    }
}
