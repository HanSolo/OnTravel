//
//  Helper.swift
//  OnTravel
//
//  Created by Gerrit Grunwald on 24.08.24.
//

import Foundation
import SwiftUI


public class Helper {
    
    public static func getLastDayOfYear() -> Date {
        let now : Date = Date.init()
        // Get the current year
        let year = Calendar.current.component(.year, from: now)
        // Get the first day of next year
        if let firstOfNextYear = Calendar.current.date(from: DateComponents(year: year + 1, month: 1, day: 1)) {
            // Get the last day of the current year
            let lastOfYear = Calendar.current.date(byAdding: .day, value: 0, to: firstOfNextYear)
            return lastOfYear!
        } else {
            return now
        }
            
    }
    
    public static func saveJson(json: String) -> Void {
        let filename     : String = "visits\(Calendar.current.component(.year, from: Date.init())).json"
        let data         : Data   = Data(json.utf8)
        let documentsUrl : URL    = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url          : URL    = documentsUrl.appendingPathComponent(filename)
        
        do {
            try data.write(to: url, options: [.atomic, .completeFileProtection])
        } catch {
            print("Error saving json file")
        }
    }
    
    public static func readJson(year: Int) -> String {
        let filename     : String = "visits\(year).json"
        let documentsUrl : URL    = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url          : URL    = documentsUrl.appendingPathComponent(filename)
        do {
            let json : String = try String(contentsOf: url)
            return json
        } catch {
            print("Error reading json file")
            return ""
        }
    }
    
    public static func getCountriesFromJson(json: String) -> [Country] {
        let data      : Data?      = json.data(using: .utf8)
        let jsonData  : [JsonData] = try! JSONDecoder().decode([JsonData].self, from: data!)
        var countries : [Country]  = []
        for jd in jsonData {
            let country : Country? = jd.getCountry()
            if nil != country { countries.append(country!) }
        }
        return countries
    }
}
