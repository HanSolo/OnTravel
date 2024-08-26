//
//  DateFormatter+convenienceInit.swift
//  OnTravel
//
//  Created by Gerrit Grunwald on 26.08.24.
//

import Foundation


extension DateFormatter {
    convenience init(dateFormat: String, calendar: Calendar) {
        self.init()
        self.dateFormat = dateFormat
        self.calendar   = calendar
    }
}
