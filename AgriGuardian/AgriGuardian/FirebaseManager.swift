//
//  FirebaseManager.swift
//  AgriGuardian
//
//  Created by Davy Chuon on 4/8/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Firebase

class FirebaseManager {
    var ref: DocumentReference? = nil
    let db = Firestore.firestore()
    
    func checkUser(completion: @escaping (Bool) -> Void) {
        ref = db.collection("users").document(Auth.auth().currentUser!.uid)
        ref?.getDocument { (snap, err) in
            if (snap?.exists)! {
                // user exists
                completion(true)
            }
            else {
                // create new user
                completion(false)
            }
        }
    }
    
    func createUser(email: String, uid: String) {
        ref = db.collection("users").document(uid)
        ref?.setData([
            "currentDevice" : "",
            "email" : email,
            "firstName" : "",
            "lastName" : "",
            "phoneNumber" : "",
            "Devices" : []
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(self.ref!.documentID)")
            }
        }
    }
    
    func loadUserProfile(completion: @escaping (User) -> Void) {
        var currUser = User()
        if let uid = Auth.auth().currentUser?.uid {
            // get user
            getUser(uid: uid) { user in
                currUser = user
            }
            // get user's devices
            getDevices(uid: uid) { devices in
                currUser.devices = devices
            }
        completion(currUser)
        }
    }
    
    func getUser(uid: String, completion: @escaping (User) -> Void) {
        db.collection("users").document(uid).getDocument() { (snap, error) in
            if let err = error {
                print("\(err)")
            }
            if let userDoc = snap {
                completion(User(data: userDoc.data()!))
            }
        }
    }
    
    func getDevices(uid: String, completion: @escaping ([Device]) -> Void) {
        var userDevices: [Device] = []
        let root = db.collection("devices").whereField("uid", isEqualTo: uid)
        root.getDocuments() {(data, error) in
            if let err = error {
                print("\(err)")
            }
            else if let deviceDocs = data?.documents {
                for devices in deviceDocs {
                    let dev = Device(data: devices.data())
                    
                    // get all rides for this device
//                    self.getRides(devId: dev.devId) { (rides) in
//                        dev.rides = rides
//                        dev.setRideHistory(history: self.getRideHistory(rides: rides))
//                        userDevices.append(dev)
//                        print("Appending dev: \(userDevices.count)")
//                    }
                    userDevices.append(dev)
                    
                }
                completion(userDevices)
            }
        }
    }
    
    func getRides(devId: String, completion: @escaping ([Ride]) -> Void) {
        var tempRides = [Ride]()
        let root = db.collection("ridehistory").whereField("dev_id", isEqualTo: devId)
        root.getDocuments() {(data, error) in
            if let err = error {
                print("\(err)")
            }
            else if let rideDocs = data?.documents {
                for rides in rideDocs {
                    let ride = Ride(data: rides.data())
                    tempRides.append(ride)
                }
                completion(tempRides)
            }
            
        }

    }
    
    func getRideHistory(rides: [Ride]) -> RideHistory {
         return organizeUserRides(rides: rides)
    }
    
    
    
    func setAccountInfo(firstName: String, lastName: String, phoneNum: String) {
        if let uid = Auth.auth().currentUser?.uid {
            ref = db.collection("users").document(uid)
            ref?.updateData([
                "firstName" : firstName,
                "lastName" : lastName,
                "phoneNumber" : phoneNum
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document updated with ID: \(self.ref!.documentID)")
                }
            }
        }
    }
    
    
    // ======= SHOULD THIS INCLUDE NAME AND VEHICLE MODEL ========
    func setCurrDevice(currDev: String) {
        ref = db.collection("users").document(Auth.auth().currentUser!.uid)
        ref?.updateData([
            "currentDevice" : currDev
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(self.ref!.documentID)")
            }
        }
    }
    
    // ==================================================================================
    
    // MARK: LOADING DATA FROM FIREBASE
    // TODO: make sure for case
    func loadDevices(completion: @escaping ([Device]) -> Void){
        var userDevices: [Device] = []
        var currUID: String = ""
        if let id = Auth.auth().currentUser?.uid {
            currUID = id
        }
//        print("CURRUID: \(currUID)")
        let root = db.collection("devices").whereField("uid", isEqualTo: currUID)
        root.getDocuments() {(data, error) in
            if let err = error {
                print("\(err)")
            }
            if let deviceDocs = data?.documents {
                for devices in deviceDocs {
                    let dev = Device(data: devices.data())
                    
                    // ===== TEMPORARY HARDCODING RIDEHISTORY =====
                    let rides = self.loadRides()
//                    dev.rideHistory = rides
                    dev.rides = rides
                    // ============================================

                    userDevices.append(dev)
                }
                completion(userDevices)
            }
        }
    }
    
    
    
    func loadDevices_tempUser(completion: @escaping (User) -> Void) {
        var user: User = User.init()
        var devices: [Device] = []
        loadDevices { userDevices in
            devices = userDevices
            if devices.count == 0 {
                user = User(firstName: "Johnny", lastName: "Farmer", phoneNumber: "7147824460", uid: "u0001", emailAddress: "jfarmer@kadd.com", devices: devices, currentDevice: Device.init())
                completion(user)
                
            }
            else {
                user = User(firstName: "Johnny", lastName: "Farmer", phoneNumber: "7147824460", uid: "u0001", emailAddress: "jfarmer@kadd.com", devices: devices, currentDevice: devices[0])
                completion(user)
            }
            
        }
    }
    

    
    func organizeUserRides(rides: [Ride]) -> RideHistory {
        var history = RideHistory()
        var years = history.getYears()
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMMM"

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
                        
                        // add total time of ride to month
                        history.years[y].months[m].time += ride.totalTime
                        
                        // add total milage of ride to month
                        history.years[y].months[m].mileage += ride.mileage
                        
                        // add total rollovers of ride to month
                        if ride.didRollover {
                            history.years[y].months[m].rollovers += 1
                        }
                    }
                }
            }
//            print("success")
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
//        thisRide.printDate()
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

