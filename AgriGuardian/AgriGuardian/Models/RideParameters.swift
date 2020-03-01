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
    var didRollover: Bool
    
    init() {
        terrain = [TerrainPoint]()
        locations = [CLLocation]()
        didRollover = false
    }
    
    func addLocation(location: CLLocation) {
        self.locations.append(location)
    }
    
    func addTerrainPoint(point: TerrainPoint) {
        self.terrain.append(point)
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
