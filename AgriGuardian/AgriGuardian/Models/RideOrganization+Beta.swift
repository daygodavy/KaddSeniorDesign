//
//  RideOrganization+Beta.swift
//  AgriGuardian
//
//  Created by Daniel Weatrowski on 5/12/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import Foundation
import MapKit

extension Device {
    
    public func addRides() {
        
        let rides = self.rides
        
        
        // change date of rides
        for ride in rides {
            var newRide = Ride()
            let locos = ride.locations
            let miles = ride.mileage
            let time = ride.totalTime
            let thirtyDaysBeforeToday = Calendar.current.date(byAdding: .day, value: -30, to: ride.rideDate)!
            newRide.setDate(date: thirtyDaysBeforeToday)
            newRide.addLocations(locos: locos)
            newRide.setMileage(mileage: miles)
            newRide.setTotalTime(time: time)
            self.rides.append(newRide)
        }
        
        // change date of rides
        for ride in rides {
            var newRide = Ride()
            let locos = ride.locations
            let miles = ride.mileage
            let time = ride.totalTime
            let thirtyDaysBeforeToday = Calendar.current.date(byAdding: .day, value: -2, to: ride.rideDate)!
            newRide.setDate(date: thirtyDaysBeforeToday)
            newRide.addLocations(locos: locos)
            newRide.setMileage(mileage: miles)
            newRide.setTotalTime(time: time)
            self.rides.append(newRide)
        }
        // change date of rides
        for ride in rides {
            var newRide = Ride()
            let locos = ride.locations
            let miles = ride.mileage
            let time = ride.totalTime
            let thirtyDaysBeforeToday = Calendar.current.date(byAdding: .day, value: -2, to: ride.rideDate)!
            newRide.setDate(date: thirtyDaysBeforeToday)
            newRide.addLocations(locos: locos)
            newRide.setMileage(mileage: miles)
            newRide.setTotalTime(time: time)
            self.rides.append(newRide)
        }
        // change date of rides
        for ride in rides {
            var newRide = Ride()
            let locos = ride.locations
            let miles = ride.mileage
            let time = ride.totalTime
            let thirtyDaysBeforeToday = Calendar.current.date(byAdding: .day, value: -100, to: ride.rideDate)!
            newRide.setDate(date: thirtyDaysBeforeToday)
            newRide.addLocations(locos: locos)
            newRide.setMileage(mileage: miles)
            newRide.setTotalTime(time: time)
            self.rides.append(newRide)
        }
        // change date of rides
        for ride in rides {
            var newRide = Ride()
            let locos = ride.locations
            let miles = ride.mileage
            let time = ride.totalTime
            let thirtyDaysBeforeToday = Calendar.current.date(byAdding: .day, value: -150, to: ride.rideDate)!
            newRide.setDate(date: thirtyDaysBeforeToday)
            newRide.addLocations(locos: locos)
            newRide.setMileage(mileage: miles)
            newRide.setTotalTime(time: time)
            self.rides.append(newRide)
        }
        // change date of rides
        for ride in rides {
            var newRide = Ride()
            let locos = ride.locations
            let miles = ride.mileage
            let time = ride.totalTime
            let thirtyDaysBeforeToday = Calendar.current.date(byAdding: .day, value: -4, to: ride.rideDate)!
            newRide.setDate(date: thirtyDaysBeforeToday)
            newRide.addLocations(locos: locos)
            newRide.setMileage(mileage: miles)
            newRide.setTotalTime(time: time)
            self.rides.append(newRide)
        }
        

    }
    
    
}
extension Ride {
    func addLocations(locos: [CLLocation]) {
        self.locations = locos
    }
}
