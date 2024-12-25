//
//  Date+isSameDDMMYYYY.swift
//  OnTravel
//
//  Created by Gerrit Grunwald on 25.12.24.
//

import Foundation

extension Date {
    func isSameDDMMYYYY(as date: Date) -> Bool {
        let calendar : Calendar = Calendar.current
        let compare = calendar.dateComponents([.day, .month, .year], from: calendar.startOfDay(for: self), to: calendar.startOfDay(for: date))
        return compare.year == 0 && compare.month == 0 && compare.day == 0
    }
}
