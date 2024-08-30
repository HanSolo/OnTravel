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
    
    public static func getAvailableYears() -> [Int] {
        var yearsFound : Set<Int> = Set()
        let documentsUrl : URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            let pattern : Regex = try Regex("visits([0-9]{4})\\.json")
            let items = try FileManager.default.contentsOfDirectory(atPath: documentsUrl.path())
            for item in items {
                if item.starts(with: "visits") && item.hasSuffix(".json") {
                    if let match = item.firstMatch(of: pattern) {
                        let yearFound : Int = Int(match.output[1].substring!)!
                        yearsFound.insert(yearFound)
                    }
                }
            }
        } catch {
            print("Error listing files")
        }
        return Array(yearsFound)
    }
        
    public static func saveJson(json: String) -> Void {
        let fileManager : FileManager = FileManager.default
        let data        : Data        = Data(json.utf8)
                          
        if let jsonBookmark = Data(base64Encoded: Properties.instance.jsonBookmark!.data(using: .utf8)!) {
            var isStale : Bool = false
            do {
                let resolvedUrl = try URL(resolvingBookmarkData: jsonBookmark, options: [.withoutUI], bookmarkDataIsStale: &isStale)
                
                do {
                    try fileManager.setAttributes([.protectionKey: FileProtectionType.none], ofItemAtPath: resolvedUrl.path)
                } catch {
                    Swift.debugPrint("Failed to set file protection. Error: \(error.localizedDescription)")
                }
                
                if resolvedUrl.startAccessingSecurityScopedResource() {
                    do {
                        try data.write(to: resolvedUrl, options: [.atomic, .noFileProtection])
                        Swift.debugPrint("Successfully saved json file via jsonBookmark")
                        
                        if let bookmark = try? resolvedUrl.bookmarkData(options: .minimalBookmark, includingResourceValuesForKeys: nil, relativeTo: nil) {
                            Properties.instance.jsonBookmark = bookmark.base64EncodedString()
                            Swift.debugPrint("Successfully saved json bookmark to properties")
                        }
                    } catch {
                        Swift.debugPrint("Error saving json file. Error: \(error.localizedDescription)")
                    }
                }
                do { resolvedUrl.stopAccessingSecurityScopedResource() }
            } catch let error {
                Swift.debugPrint("Error resolving URL from bookmark data. Error: \(error.localizedDescription)")
            }
        } else {
            let filename : String      = "visits\(Calendar.current.component(.year, from: Date.init())).json"
            let url      : URL         = FileManager.documentsDirectory.appendingPathComponent(filename)
            
            do {
                try fileManager.setAttributes([.protectionKey: FileProtectionType.none], ofItemAtPath: url.path)
            } catch {
                Swift.debugPrint("Failed to set file protection. Error: \(error.localizedDescription)")
            }
            
            do {
                try data.write(to: url, options: [.atomic, .noFileProtection])
                Swift.debugPrint("Successfully saved json file")
                
                if let bookmark = try? url.bookmarkData(options: .minimalBookmark, includingResourceValuesForKeys: nil, relativeTo: nil) {
                    Properties.instance.jsonBookmark = bookmark.base64EncodedString()
                    Swift.debugPrint("Successfully saved json bookmark to properties")
                }
            } catch {
                Swift.debugPrint("Error saving json file. Error: \(error.localizedDescription)")
            }
        }
    }
    
    public static func readJson(year: Int) -> String {
        let fileManager : FileManager = FileManager.default
        var json        : String      = ""
                
        if let jsonBookmark = Data(base64Encoded: Properties.instance.jsonBookmark!.data(using: .utf8)!) {
            var isStale : Bool = false
            do {
                let resolvedUrl = try URL(resolvingBookmarkData: jsonBookmark, options: [.withoutUI], bookmarkDataIsStale: &isStale)
                
                do {
                    try fileManager.setAttributes([.protectionKey: FileProtectionType.none], ofItemAtPath: resolvedUrl.path)
                } catch {
                    Swift.debugPrint("Failed to set file protection. Error: \(error.localizedDescription)")
                }
                
                if resolvedUrl.startAccessingSecurityScopedResource() {
                    do {
                        json = try String(contentsOf: resolvedUrl)
                        Swift.debugPrint("Successfully read json from resolved file URL: \(resolvedUrl.path())")
                    } catch {
                        Swift.debugPrint("Error reading json file. Error: \(error.localizedDescription)")
                        json = ""
                    }
                }
                do { resolvedUrl.stopAccessingSecurityScopedResource() }
            } catch let error {
                Swift.debugPrint("Error resolving URL from bookmark data. Error: \(error.localizedDescription)")
            }
        } else {
            let filename : String = "visits\(year).json"
            let url      : URL    = FileManager.documentsDirectory.appendingPathComponent(filename)
            
            do {
                try fileManager.setAttributes([.protectionKey: FileProtectionType.none], ofItemAtPath: url.path)
            } catch {
                Swift.debugPrint("Failed to set file protection. Error: \(error.localizedDescription)")
            }
            
            do {
                json = try String(contentsOf: url)
            } catch {
                Swift.debugPrint("Error reading json file. Error: \(error.localizedDescription)")
                json = ""
            }
        }
        return json
    }
    
    public static func visitsToJson(allVisits : Set<Country>) -> String {
        if allVisits.isEmpty { return "[]" }
        
        var json : String = "["
        for country in allVisits {
            json += "{ \"iso\":\"\(country.isoInfo.alpha2)\","
            json += "\"visits\":["
            for date in country.visits {
                json += "\(date.timeIntervalSince1970),"
            }
            if country.visits.count > 0 { json.removeLast() }
            json += "]},"
        }
        if allVisits.count > 0 { json.removeLast() }
        json += "]"
        
        return json
    }
    
    public static func getCountriesFromJson(json: String) -> [Country] {
        var countries : [Country]  = []
        if json.isEmpty { return countries }
        let data      : Data?      = json.data(using: .utf8)
        let jsonData  : [JsonData] = try! JSONDecoder().decode([JsonData].self, from: data!)
        for jd in jsonData {
            let country : Country? = jd.getCountry()
            if nil != country { countries.append(country!) }
        }
        return countries
    }
    
    public static func countriesToCsv(countries: [Country]) -> String {
        let dateFormatter : DateFormatter = DateFormatter(dateFormat: "dd/MM/yyyy", calendar: Calendar.current)
        var csv           : String        = "\"iso\",\"name\",\"date\"\n"
        for country in countries {
            for date in country.visits {
                csv += "\"\(country.isoInfo.alpha2)\",\"\(country.isoInfo.name)\",\"\(dateFormatter.string(from: date))\"\n"
            }
        }
        return csv
    }
    
    public static func createCSV(year: Int) -> String {
        let json      : String    = readJson(year: year)
        let countries : [Country] = getCountriesFromJson(json: json)
        let csv       : String    = countriesToCsv(countries: countries)
        return csv
    }
}
