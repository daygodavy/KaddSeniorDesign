//
//  TestDataManager.swift
//  
//
//  Created by Daniel Weatrowski on 3/8/20.
//

import Foundation
import UIKit
import MapKit

class DataManager {
    
    func loadSampleData() -> User {
        return loadUser()
    }

    func loadUser() -> User {
        let devices = loadDevices()
        let user = User(firstName: "Johnny", lastName: "Farmer", phoneNumber: "7147824460", uid: "u0001", emailAddress: "jfarmer@kadd.com", devices: devices, currentDevice: devices[0])
        
        return user
    }
     func loadDevices() -> [Device] {
        let rides = loadRides()
        
        var device1 = Device(name: "iKadd Device", modelNumber: "A1", serialNumber: "A16DB9663", atvModel: "FOURTRAX RECON 4x4", manufacturer: "Honda", hardwareVersion: "1.0.0", firmwareVersion: "1.1.0", uid: "u0001", devId: "d0001", rideHistory: rides)
        var device2 = Device(name: "Rincon Kadd", modelNumber: "A2", serialNumber: "A26DB9663", atvModel: "FOURTRAX RINCON", manufacturer: "Honda", hardwareVersion: "1.1.0", firmwareVersion: "1.0.0", uid: "u0001", devId: "d0010", rideHistory: rides)
        var device3 = Device(name: "Griz-ly", modelNumber: "A3", serialNumber: "A36DB9663", atvModel: "Grizzly EPS XT-R", manufacturer: "Yamaha", hardwareVersion: "1.0.0", firmwareVersion: "1.1.0", uid: "u0101", devId: "d0101", rideHistory: rides)
        var device4 = Device(name: "King Kadd", modelNumber: "A4", serialNumber: "A46DB9663", atvModel: "KingQuad 750AXi Camo", manufacturer: "Suzuki", hardwareVersion: "1.0.0", firmwareVersion: "1.0.0", uid: "u1000", devId: "d1000", rideHistory: rides)
        
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
        let lastIndex = rowsInFile.count - 1
        let lastRow = rowsInFile[lastIndex]
        let tokens = lastRow.components(separatedBy: ",")
        let date = formatDateFromData(date: tokens[0])
        return date
    }
    
    func formatDateFromData(date: String) -> Date  {
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
