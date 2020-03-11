//
//  TestDataManager.swift
//  
//
//  Created by Daniel Weatrowski on 3/8/20.
//

import Foundation
import UIKit
import MapKit
import Firebase

class DataManager {
    var ref: DocumentReference? = nil
    let db = Firestore.firestore()
    // MARK: LOADING DATA FROM FIREBASE
    // TODO: make sure for case
    func loadDevices() -> [Device]{
        var userDevices: [Device] = []
        var currUID: String = ""
        if let id = Auth.auth().currentUser?.uid {
            currUID = id
        }
        let root = db.collection("devices")
        print("CURRUID: \(currUID)")
        root.getDocuments() {(data, error) in
            print("retriving documents")
            if let err = error {
                print("\(err)")
            }
            print("SKIP")
            if let deviceDocs = data?.documents {
                print("DEVICES COUNT: \(deviceDocs.count)")
                for devices in deviceDocs {
                    let dev = Device(data: devices.data())
                    
                    // ===== TEMPORARY HARDCODING RIDEHISTORY =====
                    let rides = self.loadRides()
                    dev.rideHistory = rides
                    // ============================================

                    userDevices.append(dev)
                }
            }
        }
        print("NUM USER DEVICES \(userDevices.count)")
        return userDevices
    }
    
    func loadDevices_tempUser() -> User {
        let devices = loadDevices()
        let user = User(firstName: "Johnny", lastName: "Farmer", phoneNumber: "7147824460", uid: "u0001", emailAddress: "jfarmer@kadd.com", devices: devices, currentDevice: devices[0])
        
        return user
    }
    
    
    
    
    
    // MARK: HARDCODED SAMPLE DATA BELOW, SCRAP AFTER FIREBASE INTEGRATION
    
    func loadSampleData() -> User {
        return loadUser()
    }

    func loadUser() -> User {
        let devices = loadDevs()
        let user = User(firstName: "Johnny", lastName: "Farmer", phoneNumber: "7147824460", uid: "u0001", emailAddress: "jfarmer@kadd.com", devices: devices, currentDevice: devices[0])
        
        return user
    }
     func loadDevs() -> [Device] {
        let rides = loadRides()
        
        var device1 = Device(name: "iKadd Device", modelNumber: "A1", serialNumber: "A16DB9663", atvModel: "FOURTRAX RECON 4x4", manufacturer: "Honda", hardwareVersion: "1.0.0", firmwareVersion: "1.1.0", uid: "u0001", devId: "d0001", rideHistory: rides, gfT: false, gfR: 0, gfC: CLLocation.init())
        var device2 = Device(name: "Rincon Kadd", modelNumber: "A2", serialNumber: "A26DB9663", atvModel: "FOURTRAX RINCON", manufacturer: "Honda", hardwareVersion: "1.1.0", firmwareVersion: "1.0.0", uid: "u0001", devId: "d0010", rideHistory: rides, gfT: false, gfR: 0, gfC: CLLocation.init())
        var device3 = Device(name: "Griz-ly", modelNumber: "A3", serialNumber: "A36DB9663", atvModel: "Grizzly EPS XT-R", manufacturer: "Yamaha", hardwareVersion: "1.0.0", firmwareVersion: "1.1.0", uid: "u0101", devId: "d0101", rideHistory: rides, gfT: false, gfR: 0, gfC: CLLocation.init())
        var device4 = Device(name: "King Kadd", modelNumber: "A4", serialNumber: "A46DB9663", atvModel: "KingQuad 750AXi Camo", manufacturer: "Suzuki", hardwareVersion: "1.0.0", firmwareVersion: "1.0.0", uid: "u1000", devId: "d1000", rideHistory: rides, gfT: false, gfR: 0, gfC: CLLocation.init())
        
        let testDevices = [device1, device2, device3, device4]
        
        return testDevices
        
    }
    
     func loadRides() -> [Ride] {
        var tempRides = [Ride]()
        for _ in 0..<4 {
            let ride = loadGPSData(csvFile: "gps_2020_03_09", ofType: "csv")
            tempRides.append(ride)
        }
        return tempRides
    }
    
    func loadGPSData(csvFile: String, ofType filetype: String) -> Ride {
        let thisRide = Ride()
        guard let filepath = Bundle.main.path(forResource: csvFile, ofType: filetype) else {
            fatalError("Unable to load CSV in main bundle")
        }
        do {
            let contents = try String(contentsOfFile: filepath, encoding: .utf8)
            let rows = contents.components(separatedBy: "\n")
            print(rows.count)
            for item in rows {
                // split row into tokens
                // timestamp, latitude, longitude, speed, altitude, sat
                let tokens = item.components(separatedBy: ",")
                if tokens.count < 5 {
                    print("IN HEREEEEEEE")
                    continue
                }
                print(tokens)
                guard let latitude = Double(tokens[1]) else {
                    fatalError("Unexpectedly found nil trying to convert latitude to Double value")
                }
                guard let longitude = Double(tokens[2]) else {
                    fatalError("Unexpectedly found nil trying to convert longitude to Double value")
                }
                
                let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
                let date = formatDateFromData(date: tokens[0])
                let speed = CLLocationSpeed(string: tokens[3])
                let altitude = CLLocationDistance(string: tokens[4])!

                let location = CLLocation(coordinate: coordinate, altitude: altitude, horizontalAccuracy: 0, verticalAccuracy: 0, course: -1, speed: speed!, timestamp: date)
                
                thisRide.addLocation(location: location)
            }
            // get total ride length
            let startTime = getEndTime(rowsInFile: rows)
            let endTime = getEndTime(rowsInFile: rows)
            let rideTime = endTime.timeIntervalSince(startTime)
            
            thisRide.setTotalTime(time: rideTime)
         } catch {
             fatalError("Unable to load file contents")
         }
        return thisRide
    }
    
    func getStartTime(rowsInFile: [String]) -> Date {
        let firstRow = rowsInFile[0]
        let tokens = firstRow.components(separatedBy: ",")
        let date = formatDateFromData(date: tokens[0])
        return date
    }
    
    func getEndTime(rowsInFile: [String]) -> Date {
        let lastIndex = rowsInFile.count - 2
        let lastRow = rowsInFile[lastIndex]
        let tokens = lastRow.components(separatedBy: ",")
        let date = formatDateFromData(date: tokens[0])
        return date
    }
    
    func formatDateFromData(date: String) -> Date  {
        print(date)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let thisDate = formatter.date(from: date)
        if let date = thisDate {
            return date
        } else {
            fatalError("Unable to convert date to Date()")
        }
    }
}
