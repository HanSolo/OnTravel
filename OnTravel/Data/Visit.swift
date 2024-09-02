//
//  VisitData.swift
//  OnTravel
//
//  Created by Gerrit Grunwald on 02.09.24.
//

import Foundation
import SwiftData


@Model
public class Visit: Codable, Hashable, Identifiable {
    enum CodingKeys: CodingKey {
        case iso
        case visits
    }
    
        
    var iso    : String?
    var visits : [Double]?
    
    
    init(iso: String, visits: [Double]) {
        self.iso    = iso
        self.visits = visits
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.iso      = try container.decode(String.self,   forKey: .iso)
        self.visits   = try container.decode([Double].self, forKey: .visits)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.iso,    forKey: .iso)
        try container.encode(self.visits, forKey: .visits)
    }
    
    public func addVisit(date: Date) -> Void {
        if nil == self.visits { return }
        let calendar : Calendar = Calendar.current
        let exists   : Bool     = self.visits!.filter({ calendar.component(.year,  from: Date.init(timeIntervalSince1970: $0)) == calendar.component(.year,  from: date) &&
                                                        calendar.component(.month, from: Date.init(timeIntervalSince1970: $0)) == calendar.component(.month, from: date) &&
                                                        calendar.component(.day,   from: Date.init(timeIntervalSince1970: $0)) == calendar.component(.day,   from: date)}).count > 0
        if exists {
            debugPrint("Date already exists in visit")
            return
        }
        self.visits!.append(date.timeIntervalSince1970)
    }
    
    
    public func getVisitsIn(month : Int, year: Int) -> Int {
        precondition((1...12).contains(month))
        precondition((1970...3000).contains(year))
        if nil == self.visits { return 0 }
        let calendar : Calendar = Calendar.current
        return self.visits!.filter({ calendar.component(.year, from: Date.init(timeIntervalSince1970: $0)) == year && calendar.component(.month, from: Date.init(timeIntervalSince1970: $0)) == month }).count
    }
    
    public func getVisitsIn(year : Int) -> Int {
        precondition((1970...3000).contains(year))
        if nil == self.visits { return 0 }
        let calendar : Calendar = Calendar.current
        return self.visits!.filter( { calendar.component(.year, from: Date.init(timeIntervalSince1970: $0)) == year }).count
    }
    
    public func getAllVisits() -> Int {
        if nil == self.visits { return 0}
        return self.visits!.count
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(iso)
    }
    
    public static func == (lhs: Visit, rhs: Visit) -> Bool {
        return lhs.iso == rhs.iso
    }
}
