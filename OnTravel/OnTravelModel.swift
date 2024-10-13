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
    @Published var lastGeoCodeLat       : Double         = 0.0
    @Published var lastGeoCodeLon       : Double         = 0.0
    @Published var country              : String         = ""
    @Published var allVisits            : Set<Country>   = Set<Country>() {
        didSet {
            /*
            self.allVisitsWithoutHome.removeAll()
            for country in allVisits.filter({ $0.isoInfo.alpha2 != self.homeCountry.alpha2 }) {
                self.allVisitsWithoutHome.insert(country)
            }
            */
        }
    }
    //@Published var allVisitsWithoutHome : Set<Country>   = Set<Country>()
    @Published var remainingDays        : Int            = 0
    @Published var availableYears       : [Int]          = Helper.availableYears()
    @Published var homeCountry          : IsoCountryInfo = IsoCountries.allCountries[Properties.instance.homeCountryIndex!]
    @Published var ignoreHomeCountry    : Bool           = Properties.instance.ignoreHomeCountry!
    @Published var metric               : Bool           = Properties.instance.metric!
    @Published var selectedMonth        : Int            = Calendar.current.component(.month, from: Date.now)
    
    
    
    public func totalDaysOnTravel() -> Int {
        return self.allVisits.map( {$0.visits.count }).reduce(0, +)
    }
    
    public func daysOnTravelOutsideHomeCountry() -> Int {
        var daysOutsideHomeCountry : Int = 0
        for country in self.allVisits {
            if country.isoInfo.alpha2 != self.homeCountry.alpha2 {
                daysOutsideHomeCountry += country.getAllVisits()
            }
        }
        return daysOutsideHomeCountry        
    }
    
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
        let dateFormatter : DateFormatter = DateFormatter(dateFormat: self.metric ? Constants.METRIC_DATE_FORMAT : Constants.IMPERIAL_DATE_FORMAT, calendar: Calendar.current)
        var csv           : String        = "\"iso\",\"name\",\"date\"\n"
        for country in self.allVisits {
            for date in country.visits {
                csv += "\"\(country.isoInfo.alpha2)\",\"\(country.isoInfo.name)\",\"\(dateFormatter.string(from: date))\"\n"
            }
        }
        return csv
    }
}
