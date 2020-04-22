//
//  RideOrganization.swift
//  AgriGuardian
//
//  Created by Daniel Weatrowski on 3/10/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import Foundation
public final class RideHistory {
    var years: [RideYear]
    
    init() {
        years = [RideYear]()
    }
    func getYears() -> [RideYear] {
        return self.years
    }
    func getMonths(yearIndex: Int) -> [RideMonth] {
        return self.years[yearIndex].months
    }
    func getMonth(yearIndex: Int, monthIndex: Int) -> RideMonth {
        return self.years[yearIndex].months[monthIndex]
    }
    func getMonthName(yearIndex: Int, monthIndex: Int) -> String {
        return self.years[yearIndex].months[monthIndex].getMonthName()
    }
    func getYearName(yearIndex: Int) -> String {
        return self.years[yearIndex].yearName
    }
    func addYear(newYear: RideYear) {
        self.years.append(newYear)
    }
    func addMonth(yearIndex: Int, newMonth: RideMonth) {
        let currYear = self.years[yearIndex]
        currYear.months.append(newMonth)
    }
    func addRide(yearIndex: Int, monthIndex: Int, newRide: Ride) {
        let currMonth = self.years[yearIndex].months[monthIndex]
        currMonth.rides.append(newRide)
    }

}
public final class RideYear: Equatable {
    var yearName: String
    var months: [RideMonth]
    
    init() {
        yearName = ""
        months = [RideMonth]()
    }
    init(year: String) {
        self.yearName = year
        self.months = [RideMonth]()
    }
    func setYear(year: String) {
        self.yearName = year
    }
    func getMonths() -> [RideMonth] {
        return self.months
    }
    func addMonth(newMonth: RideMonth) {
        self.months.append(newMonth)
    }
    public static func ==(lhs:RideYear, rhs:RideYear) -> Bool {
        return lhs.yearName == rhs.yearName
    }
}
public final class RideMonth: Equatable {
    var monthName: String
    var rides: [Ride]
    var mileage: Double
    var time: TimeInterval
    var rollovers: Int
    
    init() {
        monthName = ""
        rides = [Ride]()
        mileage = 0.0
        time = 0.0
        rollovers = 0
    }
    init(monthName: String) {
        self.monthName = monthName
        rides = [Ride]()
        mileage = 0.0
        time = 0.0
        rollovers = 0
    }
    
    init(monthName: String, rides: [Ride], mileage: Double, time: Double, rollovers: Int) {
        self.monthName = monthName
        self.rides = rides
        self.mileage = mileage
        self.time = time
        self.rollovers = rollovers
    }
    public static func ==(lhs:RideMonth, rhs:RideMonth) -> Bool {
        return lhs.monthName == rhs.monthName
    }
    public func getMonthName() -> String {
        return self.monthName
    }
    public func getRide(rideIndex: Int) -> Ride {
        return self.rides[rideIndex]
    }
    func addRide(ride: Ride) {
        self.rides.append(ride)
    }
    
    
//    func getMonthLabel() -> String {
//
//    }
    
    func getMileageLabel() -> String {
        let meters = Measurement(value: self.mileage, unit: UnitLength.meters)
        let mileage = meters.converted(to: UnitLength.miles)
        return String(format: "%.2f", mileage.value)
    }
    
    func getTimeLabel() -> String {
        return self.time.stringFromTimeInterval()
    }
    
}

