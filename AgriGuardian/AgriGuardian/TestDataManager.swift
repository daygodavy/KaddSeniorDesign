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
        let history = organizeUserRides(rides: rides)
        
        var device1 = Device(name: "iKadd Device", modelNumber: "A1", serialNumber: "A16DB9663", atvModel: "FOURTRAX RECON 4x4", manufacturer: "Honda", hardwareVersion: "1.0.0", firmwareVersion: "1.1.0", uid: "u0001", devId: "d0001", rideHistory: history)
        var device2 = Device(name: "Rincon Kadd", modelNumber: "A2", serialNumber: "A26DB9663", atvModel: "FOURTRAX RINCON", manufacturer: "Honda", hardwareVersion: "1.1.0", firmwareVersion: "1.0.0", uid: "u0001", devId: "d0010", rideHistory: history)
        var device3 = Device(name: "Griz-ly", modelNumber: "A3", serialNumber: "A36DB9663", atvModel: "Grizzly EPS XT-R", manufacturer: "Yamaha", hardwareVersion: "1.0.0", firmwareVersion: "1.1.0", uid: "u0101", devId: "d0101", rideHistory: history)
        var device4 = Device(name: "King Kadd", modelNumber: "A4", serialNumber: "A46DB9663", atvModel: "KingQuad 750AXi Camo", manufacturer: "Suzuki", hardwareVersion: "1.0.0", firmwareVersion: "1.0.0", uid: "u1000", devId: "d1000", rideHistory: history)
        
        let testDevices = [device1, device2, device3, device4]
        
        return testDevices
        
    }
    
    func organizeUserRides(rides: [Ride]) -> RideHistory {
        var history = RideHistory()
        var years = history.getYears()
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MM"

        // sort rides by date
        let sortedRidesbyDate = rides.sorted { $0.rideDate < $1.rideDate }
        
        for ride in sortedRidesbyDate {
            let date = ride.rideDate
            let year = yearFormatter.string(from: date)
            let month = monthFormatter.string(from: date)
            
            let tempRideYear = RideYear(year: year)
            if (!years.contains(tempRideYear)) {
                years.append(tempRideYear)
                history.addYear(newYear: tempRideYear)
            }
            // iterate through months in ride year
            for y in 0..<history.getYears().count {
                let tempRideMonth = RideMonth(monthName: month)
                let months = history.getMonths(yearIndex: y)
                let currYear = history.getYears()[y]
                
                // check if month already exists in scope of year
                if (!months.contains(tempRideMonth) && currYear.yearName == year) {
                    // add month to history
//                    months.append(tempRideMonth)
//                    tempRideYear.addMonth(newMonth: tempRideMonth)
                    history.addMonth(yearIndex: y, newMonth: tempRideMonth)
                }
                for m in 0..<history.getMonths(yearIndex: y).count {
                    let monthName = history.getMonthName(yearIndex: y, monthIndex: m)
                    // compare current month name with ride month
                    if (monthName == month) {
                        history.addRide(yearIndex: y, monthIndex: m, newRide: ride)
                    }
                }
            }
            print("success")
        }
        return history
    }
    
     func loadRides() -> [Ride] {
        var tempRides = [Ride]()
        for i in 0..<4 {
            let ride = loadGPSData(csvFile: "gps_2020_03_09", ofType: "csv")
            if (i == 2) {
                let dateStr = "2020-02-22 19:25:46.757433"
                let date = formatDateFromData(data: dateStr)
                ride.setDate(date: date)
            }
            if (i == 3) {
                let dateStr = "2016-06-22 19:25:46.757433"
                let date = formatDateFromData(data: dateStr)
                ride.setDate(date: date)
            }
            if (i == 1) {
                let dateStr = "2019-04-20 19:25:46.757433"
                let date = formatDateFromData(data: dateStr)
                ride.setDate(date: date)
            }
            tempRides.append(ride)
        }
        return tempRides
    }
    
    func loadGPSData(csvFile: String, ofType filetype: String) -> Ride {
        let thisRide = Ride()
        var mileage: Double = 0.0
        var rideDate = Date()
        var previousLocation = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        guard let filepath = Bundle.main.path(forResource: csvFile, ofType: filetype) else {
            fatalError("Unable to load CSV in main bundle")
        }
        do {
            let contents = try String(contentsOfFile: filepath, encoding: .utf8)
            let rows = contents.components(separatedBy: "\n")
//            print(rows.count)
            for item in rows {
                // split row into tokens
                // timestamp, latitude, longitude, speed, altitude, sat
                let tokens = item.components(separatedBy: ",")
                if tokens.count < 5 {
                    break
                }
                guard let latitude = Double(tokens[1]) else {
                    fatalError("Unexpectedly found nil trying to convert latitude to Double value")
                }
                guard let longitude = Double(tokens[2]) else {
                    fatalError("Unexpectedly found nil trying to convert longitude to Double value")
                }
                
                let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
                let date = formatDateFromData(data: tokens[0])
                let speed = CLLocationSpeed(string: tokens[3])
                let altitude = CLLocationDistance(string: tokens[4])!

                let location = CLLocation(coordinate: coordinate, altitude: altitude, horizontalAccuracy: 0, verticalAccuracy: 0, course: -1, speed: speed!, timestamp: date)
                
                if (mileage == 0.0) {
                    rideDate = date
                }
                
                
                mileage += getDistanceBetweenCoordinates(prev: previousLocation, curr: coordinate)
                previousLocation = coordinate
                
                thisRide.addLocation(location: location)
            }
            // get total ride length
            let startTime = getStartTime(rowsInFile: rows)
            let endTime = getEndTime(rowsInFile: rows)
            let rideTime = endTime.timeIntervalSince(startTime)
            
            thisRide.setTotalTime(time: rideTime)
//            print(rideTime.description)
            thisRide.setMileage(mileage: mileage)
//            print(rideDate.description)
            thisRide.setDate(date: rideDate)
         } catch {
             fatalError("Unable to load file contents")
         }
        thisRide.printDate()
        return thisRide
    }

    func getDistanceBetweenCoordinates(prev: CLLocationCoordinate2D, curr: CLLocationCoordinate2D) -> Double {
        if (prev.longitude == 0.0 && prev.latitude == 0.0) {
            return 0.0
        }
        let prevLocation = CLLocation(latitude: prev.latitude, longitude: prev.longitude)
        let currLocation = CLLocation(latitude: curr.latitude, longitude: curr.longitude)
       
        return currLocation.distance(from: prevLocation)
       
    }
    
    func getStartTime(rowsInFile: [String]) -> Date {
        let firstRow = rowsInFile[0]
        let tokens = firstRow.components(separatedBy: ",")
//        print("First Row Time: \(tokens[0])")
        let date = formatDateFromData(data: tokens[0])
        return date
    }
    
    func getEndTime(rowsInFile: [String]) -> Date {
        let lastIndex = rowsInFile.count - 2
        let lastRow = rowsInFile[lastIndex]
        let tokens = lastRow.components(separatedBy: ",")
//        print("Last Row Time: \(tokens[0])")

        let date = formatDateFromData(data: tokens[0])
        
        return date
    }
    
    func formatDateFromData(data: String) -> Date  {
        let temp = data.dropLast(2)
        let temp2 = String(temp)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        if let thisDate = formatter.date(from: temp2) {
//            print(thisDate.description)
            return thisDate
        } else {
            fatalError("Unable to convert date to Date()")
        }
    }
}
