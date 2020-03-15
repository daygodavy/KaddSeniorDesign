//
//  RideParameters.swift
//  AgriGuardian
//
//  Created by Daniel Weatrowski on 2/29/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import Foundation
import CoreLocation

public class Ride {
    
    var terrain: [TerrainPoint]
    var locations: [CLLocation]
    var totalTime: TimeInterval
    var mileage: Double
    var didRollover: Bool
    var rideDate: Date
    
    init() {
        terrain = [TerrainPoint]()
        locations = [CLLocation]()
        totalTime = TimeInterval()
        didRollover = false
        mileage = 0.0
        rideDate = Date()
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
        return String(self.totalTime)
    }
    func getMileage() -> String {
        return String(self.mileage)
    }
    func getTopSpeed() -> String {
        let points = self.locations
        let topSpeedLoco = points.max { a, b in a.speed < b.speed }
        if let topSpeed =  topSpeedLoco?.speed {
            return String(topSpeed)
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
        return String(avg)
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
    
}

public class TerrainPoint {
    var x: Double
    var y: Double
    var z: Double
    var rollover: Bool
    
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
