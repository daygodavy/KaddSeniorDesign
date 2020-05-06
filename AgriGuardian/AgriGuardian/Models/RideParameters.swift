//
//  RideParameters.swift
//  AgriGuardian
//
//  Created by Daniel Weatrowski on 2/29/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase

public class Ride {
    
    var terrain: [TerrainPoint]
    var locations: [CLLocation] // will hold coords, timestamps, velocities, altitudes
    var totalTime: TimeInterval
    var mileage: Double
    var didRollover: Bool
    var rideDate: Date
    
    var devId: String
    var devIdx: Int
    // left out satellines & terrain points

    
    init() {
        terrain = [TerrainPoint]()
        locations = [CLLocation]()
        totalTime = TimeInterval()
        didRollover = false
        mileage = 0.0
        rideDate = Date()
        devId = ""
        devIdx = 0
    }
    
    
    // Reading data into from Firebase
    init(data: [String: Any]) {
        self.locations = [CLLocation]()
        self.mileage = 0.0
        self.rideDate = Date()
        terrain = [TerrainPoint]()
        totalTime = TimeInterval()
        
        let tempAlts: [Double] = data["altitudes"] as! [Double]
        let tempGPs: [GeoPoint] = data["coordinates"] as! [GeoPoint]
        let tempVels: [Double] = data["velocities"] as! [Double]
        let tempTimes: [Timestamp] = data["gps_timestamps"] as! [Timestamp]
        var prevPoint: CLLocation = CLLocation.init()
        var currPoint: CLLocation = CLLocation.init()
        
        for (idx, gp) in tempGPs.enumerated() {
            let point = CLLocationCoordinate2D.init(latitude: gp.latitude, longitude: gp.longitude)
            let alt = CLLocationDistance.init(tempAlts[idx])
            let vel = CLLocationSpeed.init(tempVels[idx])
            let time: Date = tempTimes[idx].dateValue()
            
            let tempAcc = CLLocationAccuracy.init()
            
            // DEFAULT ACCURACY AND COURSE SET FOR NOW......
            let currLocation = CLLocation.init(coordinate: point, altitude: alt, horizontalAccuracy: tempAcc, verticalAccuracy: tempAcc, course: 0, speed: vel, timestamp: time)

            self.locations.append(currLocation)
            
            
            // computing mileage
            if idx > 0 {
                currPoint = currLocation
                self.mileage += currPoint.distance(from: prevPoint)
            }
            prevPoint = currLocation
        }
        
    
        self.devIdx = data["index"] as! Int
        self.devId = data["dev_id"] as! String
        self.didRollover = data["did_rollover"] as! Bool
        
        
        if let begin = self.locations.first, let end = self.locations.last {
            self.rideDate = begin.timestamp
            self.totalTime = end.timestamp.timeIntervalSince(begin.timestamp)
        }
    
    }

    
    /**
        Set Method for Ride locations attribute. Adds a new location point to this ride's current array of CLLocations
     - Parameter location: CLLocation representation of a single GPS cooridate
     - Authors: Daniel Weatrowski
     - Version: 1.0
     - Date: March 15, 2020
     - Returns: No Return value
     */
    func addLocation(location: CLLocation) {
        self.locations.append(location)
    }
    /**
        Set Method for Ride terrains attribute. Adds a new terrain point to this ride's current array of TerrainPoints
     - Parameter point: TerrainPoint representation of a single IMU cooridate
     - Authors: Daniel Weatrowski
     - Version: 1.0
     - Date: March 15, 2020
     - Returns: No Return value
     */
    func addTerrainPoint(point: TerrainPoint) {
        self.terrain.append(point)
    }
    /**
        Set Method for Ride time attribute. Sets the total time attribute for single ride
     - Parameter time: TimeInterval (Double) representation of the total time
     - Authors: Daniel Weatrowski
     - Version: 1.0
     - Date: March 15, 2020
     - Returns: No Return value
     */
    func setTotalTime(time: TimeInterval) {
        self.totalTime = time
    }
    /**
        Set Method for Ride mileage attribute. Sets the total mileage attribute for single ride
     - Parameter mileage: Total mileage of a Ride as a Double
     - Authors: Daniel Weatrowski
     - Version: 1.0
     - Date: March 15, 2020
     - Returns: No Return value
     */
    func setMileage(mileage: Double) {
        self.mileage = mileage
    }
    /**
        Set Method for Ride date attribute. Sets the date for which a single ride took place.
     - Parameter date: Date in which the current ride took place
     - Authors: Daniel Weatrowski
     - Version: 1.0
     - Date: March 15, 2020
     - Returns: No Return value
     */
    func setDate(date: Date) {
        self.rideDate = date
    }
    func printDate() {
        print(self.rideDate.description)
    }
    func getTime() -> String {
        return self.totalTime.stringFromTimeInterval()
    }
    func getMileage() -> String {
        let meters = Measurement(value: self.mileage, unit: UnitLength.meters)
        let mileage = meters.converted(to: UnitLength.miles)
        return String(format: "%.2f", mileage.value)
    }
    func getTopSpeed() -> String {
        let points = self.locations
        let topSpeedLoco = points.max { a, b in a.speed < b.speed }
        if let topSpeed =  topSpeedLoco?.speed {
            let mps = Measurement(value: topSpeed, unit: UnitSpeed.metersPerSecond)
            let mph = mps.converted(to: UnitSpeed.milesPerHour)
            return String(format: "%.2f", mph.value)
        } else {
            fatalError("Unable to get top speed")
        }
    }
    func getAvgSpeed() -> String {
        var sum: Double = 0.0
        for loc in self.locations {
            let speed = loc.speed
            sum += speed
        }
        let avg = sum / Double(self.locations.count)
        let mps = Measurement(value: avg, unit: UnitSpeed.metersPerSecond)
        let mph = mps.converted(to: UnitSpeed.milesPerHour)
        return String(format: "%.2f", mph.value)
    }
    func getRideCity(completion: @escaping (String) -> Void) {
        let geoCoder = CLGeocoder()
        let startingPoint = self.locations[0]
        var thisCity = ""
        geoCoder.reverseGeocodeLocation(startingPoint) { (placemark, error) in
            guard let marker = placemark?.first else {
                fatalError("Cannot find placemarker in getRideCity()")
            }
            if let city = marker.subAdministrativeArea {
                thisCity = city
            } else {
                thisCity = "Unknown"
            }
            completion(thisCity)
        }
    }
    func isSameDate(date: Date) -> Bool {
        return self.rideDate == date
    }
    
}

public class TerrainPoint {
    var x: Double
    var y: Double
    var z: Double
    var rollover: Bool
//    var timestamp: [Date]
    
    init() {
        x = 0.0
        y = 0.0
        z = 0.0
        rollover = false
    }
    
    init(x: Double, y: Double, z: Double, rollover: Bool) {
        self.x = x
        self.y = y
        self.z = z
        self.rollover = rollover
    }
}
