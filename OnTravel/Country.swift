//
//  Country.swift
//  CountryCounter
//
//  Created by Gerrit Grunwald on 21.08.24.
//

import Foundation


public class Country : Hashable, Identifiable {
    public  let id      : String
    public  let isoInfo : IsoCountryInfo
    public  var visits  : Set<Date>
    
    
    init(isoInfo : IsoCountryInfo) {
        self.id      = isoInfo.alpha2
        self.isoInfo = isoInfo
        self.visits  = []
    }
    
    
    public func addVisit(date: Date) -> Void {
        let calendar : Calendar = Calendar.current
        let exists   : Bool     = self.visits.filter({ calendar.component(.year, from: $0)  == calendar.component(.year, from: date) &&
                                                       calendar.component(.month, from: $0) == calendar.component(.month, from: date) &&
                                                       calendar.component(.day, from: $0)   == calendar.component(.day, from: date)}).count > 0
        if exists { return }
        self.visits.insert(date)
    }
    
    
    public func getVisitsIn(month : Int, year: Int) -> Int {
        precondition((1...12).contains(month))
        precondition((1970...3000).contains(year))
        let calendar : Calendar = Calendar.current
        return self.visits.filter({ calendar.component(.year, from: $0) == year && calendar.component(.month, from: $0) == month }).count
    }
    
    public func getVisitsIn(year : Int) -> Int {
        precondition((1970...3000).contains(year))
        let calendar : Calendar = Calendar.current
        return self.visits.filter( { calendar.component(.year, from: $0) == year }).count
    }
    
    public func getAllVisits() -> Int { return self.visits.count }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(isoInfo.alpha2)
    }
    
    public static func == (lhs: Country, rhs: Country) -> Bool {
        return lhs.isoInfo.alpha2 == rhs.isoInfo.alpha2 &&
               lhs.isoInfo.alpha3 == rhs.isoInfo.alpha3 &&
               lhs.isoInfo.name   == rhs.isoInfo.name
    }
}
