//
//  CCModel.swift
//  CountryCounter
//
//  Created by Gerrit Grunwald on 20.08.24.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit



public class OnTravelModel : ObservableObject {
    //@Published var networkMonitor     : NetworkMonitor = NetworkMonitor()
    @Published var lastGeoCodeLat     : Double       = 0.0
    @Published var lastGeoCodeLon     : Double       = 0.0
    @Published var country            : String       = ""
    @Published var allVisits          : Set<Country> = Set<Country>()
    @Published var remainingDays      : Int          = 0
    @Published var availableYears     : [Int]        = Helper.availableYears()
    
    
    public func toJson() -> String {
        var jsonTxt : String = "["
        for country in self.allVisits {
            jsonTxt += "{ \"iso\":\"\(country.isoInfo.alpha2)\","
            jsonTxt += "\"visits\":["
            for date in country.visits {
                jsonTxt += "\(date.timeIntervalSince1970),"
            }
            if country.visits.count > 0 { jsonTxt.removeLast() }
            jsonTxt += "]},"
        }
        if self.allVisits.count > 0 { jsonTxt.removeLast() }
        jsonTxt += "]"
        return jsonTxt
    }
    
    public func toCSV() -> String {
        let dateFormatter : DateFormatter = DateFormatter(dateFormat: "dd/MM/yyyy", calendar: Calendar.current)
        var csv           : String        = "\"iso\",\"name\",\"date\"\n"
        for country in self.allVisits {
            for date in country.visits {
                csv += "\"\(country.isoInfo.alpha2)\",\"\(country.isoInfo.name)\",\"\(dateFormatter.string(from: date))\"\n"
            }
        }
        return csv
    }
}
