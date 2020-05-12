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
    func getCurrentMonth() -> RideMonth {
        let year = self.years.last
        let months = year?.getMonths()
        if let month = months?.last {
            return month
        } else {
            return RideMonth()
        }
    }
    func getPreviousMonth() -> RideMonth {
        let year = self.years.last
        if let months = year?.getMonths() {
            let count = months.count
            // minus 2 to get the second to last month in the array
            return months[count - 2]
        } else {
            return RideMonth()
        }
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
    func getRides() -> [Ride] {
        return self.rides
    }
    
    func getMileageLabel() -> String {
        return String(format: "%.2f", self.mileage)
    }
    
    func getTimeLabel() -> String {
        return self.time.stringFromTimeInterval()
    }
    
}


    
public final class RideWeek {

    var week: [RideDay]
    
    init() {
        self.week = [RideDay]()
    }

    
    // pass in both month incase new month began during the current week
    init(currMonth: RideMonth, prevMonth: RideMonth) {
        
        var week = [RideDay]()
        
        var rides = currMonth.getRides()
        rides.append(contentsOf: prevMonth.getRides())
        

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let dayOfWeek = calendar.component(.weekday, from: today)
        let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: today)!
        let days = (weekdays.lowerBound ..< weekdays.upperBound)
            .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: today) }
            .filter { today >= $0 } // not sure if this works but it should filter out all dates greater than today
        // we now have array of days so find rides such that ride date matches the date index of days
        // get rides with corresponding date

        for j in 0..<days.count {
            print(days[j].description)
            
        }
        var dayIndex = 0;
        for day in days {
            let tempDay = RideDay()
            week.append(tempDay)
            for ride in rides {
                if (ride.isSameDate(date: day)) {
                    // do something here
                    print("match!")
                    week[dayIndex].ride.append(ride)
                    week[dayIndex].date = day
                    week[dayIndex].mileage += ride.mileage
                    print(ride.mileage)
                }
            }
            dayIndex += 1
        }
        
        // week contains an array of ride arrays corresponding to monday, tuesday, wednesday, etc.
        
        self.week = week
    }
    
    func getTotalMileage() -> String {
        var mileage = 0.0
        for i in 0..<self.week.count {
            for ride in self.week[i].ride {
                mileage += ride.mileage
            }
        }
        return String(format: "%.2f", mileage)

    }
    
    func getTotalHours() -> String {
        var hours = 0.0
        for i in 0..<self.week.count {
            for ride in self.week[i].ride {
                let seconds = Measurement(value: ride.totalTime, unit: UnitDuration.seconds)
                let tempHours = seconds.converted(to: UnitDuration.hours)
                hours += tempHours.value
            }
        }
        return String(format: "%.2f", hours)
    }
    
    func getTotalRollovers() -> String {
        var rolls = 0
        for i in 0..<self.week.count {
            for ride in self.week[i].ride {
                if (ride.didRollover) {
                    rolls += 1
                }
            }
        }
        return String(format: "%.2f", rolls)
    }
    
    func getLastRideDate() -> String {
        var allRides = [Ride]()
        for i in 0..<self.week.count {
            for ride in self.week[i].ride {
                allRides.append(ride)
            }
        }
        guard let lastRide = allRides.last else {
            fatalError("Unnexpectedly found nil while trying to get last ride from ride week")
        }
        
        let lastDate = lastRide.rideDate
        if (lastDate == Date()) {
            return "Today"
        }
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let now = df.string(from: lastDate)
        return now
        
    }
    func getDaysSinceLastRide() -> String {
        var allRides = [Ride]()
        for i in 0..<self.week.count {
            for ride in self.week[i].ride {
                allRides.append(ride)
            }
        }
        guard let lastRide = allRides.last else {
            return "0"
//            fatalError("Unnexpectedly found nil while trying to get last ride from ride week")
        }
        
        let lastDate = lastRide.rideDate
        if (lastDate == Date()) {
            return "Today"
        }
        guard let diffInDays = Calendar.current.dateComponents([.day], from: lastDate, to: Date()).day else {
            fatalError("Unexpectedly found nil trying to get last ride date")
        }
        return String(diffInDays)

        
    }
    
    func getLastRideTime() -> String {
        var allRides = [Ride]()
        for i in 0..<self.week.count {
            for ride in self.week[i].ride {
                allRides.append(ride)
            }
        }
        guard let lastRide = allRides.last else {
            return "00:00:00"
//            fatalError("Unexpectedly found nil while trying to get last ride from ride week")
        }
        
        let totalTime = Int(lastRide.totalTime)
        let minutes = (totalTime / 60) % 60
        let hours = (totalTime / 3600)
        
        return "\(hours) hours \(minutes) minutes"
        
    }
    
    func getLastRideMileage() -> String {
        var allRides = [Ride]()
        for i in 0..<self.week.count {
            for ride in self.week[i].ride {
                allRides.append(ride)
            }
        }
        guard let lastRide = allRides.last else {
            return "0 miles"
//            fatalError("Unexpectedly found nil while trying to get last ride from ride week")
        }
        
        let mileage = lastRide.mileage
        return String(format: "%.2f", mileage) + " miles"
    }
}

final class RideDay {
    var ride = [Ride]()
    var mileage: Double = 0
    var date = Date()
}
