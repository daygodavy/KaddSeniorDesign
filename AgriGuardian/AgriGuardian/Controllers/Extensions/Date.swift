//
//  Date.swift
//  AgriGuardian
//
//  Created by Daniel Weatrowski on 4/6/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import Foundation
import MapKit

extension Date {
    /**
        Get Date timestamp and return the time as a String.
     - Authors: Daniel Weatrowski
     - Version: 1.0
     - Date: April 6, 2020
     - Returns: String
     */
    func getTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        let thisDate = formatter.string(from: self)
        return thisDate
    }
}

extension TimeInterval {
    /**
        Converts Time interval into time stamp notation.
        Credit: https://stackoverflow.com/questions/28872450/conversion-from-nstimeinterval-to-hour-minutes-seconds-milliseconds-in-swift
        
     - Authors: Daniel Weatrowski
     - Version: 1.0
     - Date: April 6, 2020
     - Returns: String
     */
    func stringFromTimeInterval() -> String {

        let time = NSInteger(self)

        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)

        return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)

    }
}
