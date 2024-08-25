//
//  Calendar+numberOfDays.swift
//  CountryCounter
//
//  Created by Gerrit Grunwald on 23.08.24.
//

import Foundation


extension Calendar {
    func daysBetween(from: Date, to: Date) -> Int {
        let fromDate     = startOfDay(for: from)
        let toDate       = startOfDay(for: to)
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate)
        
        return numberOfDays.day!
    }
}
