//
//  Helper.swift
//  OnTravel
//
//  Created by Gerrit Grunwald on 24.08.24.
//

import Foundation
import SwiftUI


public class Helper {
   
    
    public static func lastDayOfYear() -> Date {
        let now : Date = Date.init()
        // Get the current year
        let year : Int = Calendar.current.component(.year, from: now)
        // Get the first day of next year
        if let firstOfNextYear = Calendar.current.date(from: DateComponents(year: year + 1, month: 1, day: 1)) {
            // Get the last day of the current year
            let lastOfYear = Calendar.current.date(byAdding: .day, value: 0, to: firstOfNextYear)
            return lastOfYear!
        } else {
            return now
        }
            
    }
    
    public static func availableYears() -> [Int] {
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
            Swift.debugPrint("Error listing files. Error: \(error.localizedDescription)")
        }
        return Array(yearsFound)
    }
    
    public static func visitsThisMonth(allVisits: Set<Country>) -> [Country] {
        let now            : Date      = Date.now
        let calendar       : Calendar  = Calendar.current
        let year           : Int       = calendar.component(.year, from: now)
        let month          : Int       = calendar.component(.month, from: now)
                        
        let countriesFound : [Country] = allVisits.filter({ $0.getVisitsIn(month: month, year: year) > 0 })
        return countriesFound
    }
    
    public static func visitsSelectedMonth(selectedMonth: Int, allVisits: Set<Country>) -> [Country] {                
        let month          : Int       = selectedMonth
        let countriesFound : [Country] = allVisits.filter({ $0.getVisitsSelectedMonth(month: month) > 0 })
        return countriesFound
    }
    
    public static func visitsThisYear(allVisits: Set<Country>) -> [Country] {
        let now            : Date      = Date.init()
        let calendar       : Calendar  = Calendar.current
        let year           : Int       = calendar.component(.year, from: now)
        let countriesFound : [Country] = allVisits.filter({ $0.getVisitsIn(year: year) > 0 })
        return countriesFound
    }
    
    
    public static func jsonExists(year: Int) -> Bool {
        let fileManager : FileManager = FileManager.default
        let filename    : String      = "visits\(year).json"
        let url         : URL         = FileManager.documentsDirectory.appendingPathComponent(filename)
        return fileManager.fileExists(atPath: url.path())
    }
    
    public static func saveJson(json: String) -> Void {
        Task {
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
                            //Swift.debugPrint("Successfully saved json file via jsonBookmark")
                            
                            if let bookmark = try? resolvedUrl.bookmarkData(options: .minimalBookmark, includingResourceValuesForKeys: nil, relativeTo: nil) {
                                Properties.instance.jsonBookmark = bookmark.base64EncodedString()
                                //Swift.debugPrint("Successfully saved json bookmark to properties")
                            }
                        } catch {
                            Swift.debugPrint("Error saving json file. Error: \(error.localizedDescription)")
                        }
                    }
                    do { resolvedUrl.stopAccessingSecurityScopedResource() }
                } catch let error {
                    Swift.debugPrint("Error resolving URL from bookmark data. Error: \(error.localizedDescription)")
                    
                    
                    let filename : String      = "visits\(Calendar.current.component(.year, from: Date.init())).json"
                    let url      : URL         = FileManager.documentsDirectory.appendingPathComponent(filename)
                    
                    do {
                        try fileManager.setAttributes([.protectionKey: FileProtectionType.none], ofItemAtPath: url.path)
                    } catch {
                        Swift.debugPrint("Failed to set file protection. Error: \(error.localizedDescription)")
                    }
                    
                    do {
                        try data.write(to: url, options: [.atomic, .noFileProtection])
                        //Swift.debugPrint("Successfully saved json file")
                        
                        if let bookmark = try? url.bookmarkData(options: .minimalBookmark, includingResourceValuesForKeys: nil, relativeTo: nil) {
                            Properties.instance.jsonBookmark = bookmark.base64EncodedString()
                            //Swift.debugPrint("Successfully saved json bookmark to properties")
                        }
                    } catch {
                        Swift.debugPrint("Error saving json file. Error: \(error.localizedDescription)")
                    }
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
                    //Swift.debugPrint("Successfully saved json file")
                    
                    if let bookmark = try? url.bookmarkData(options: .minimalBookmark, includingResourceValuesForKeys: nil, relativeTo: nil) {
                        Properties.instance.jsonBookmark = bookmark.base64EncodedString()
                        //Swift.debugPrint("Successfully saved json bookmark to properties")
                    }
                } catch {
                    Swift.debugPrint("Error saving json file. Error: \(error.localizedDescription)")
                }
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
                        json = try String(contentsOf: resolvedUrl, encoding: .utf8)
                        //Swift.debugPrint("Successfully read json from resolved file URL: \(resolvedUrl.path())")
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
                json = try String(contentsOf: url, encoding: .utf8)
            } catch {
                Swift.debugPrint("Error reading json file. Error: \(error.localizedDescription)")
                json = ""
            }
        }
        
        return json
    }
    
    public static func allVisitsFromFile() -> Set<Country> {
        var allVisits : Set<Country> = Set()
        let now       : Date         = Date.init()
        let year      : Int          = Calendar.current.component(.year, from: now)
        if Helper.jsonExists(year: year) {
            let json : String = Helper.readJson(year: year)
            if json.isEmpty {
                print("Json file exists, but was empty in Helper")
            } else {
                let countries : [Country] = countriesFromJson(jsonTxt: json)
                for country in countries {                    
                    allVisits.insert(country)
                }
            }
        } else {
            print("json file not found")
        }
        return allVisits
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
    
    public static func countriesFromJson(jsonTxt: String) -> [Country] {
        var countries : [Country]  = []
        if jsonTxt.isEmpty { return countries }
        let data      : Data?      = jsonTxt.data(using: .utf8)
        let jsonData  : [JsonData] = try! JSONDecoder().decode([JsonData].self, from: data!)
        for jd in jsonData {
            if let country = jd.getCountry() {
                countries.append(country)
            }
        }
        return countries
    }
    public static func countriesToJson(countries: [Country]) -> String {
        var jsonTxt : String = "["
        for country in countries {
            jsonTxt += "{ \"iso\":\"\(country.isoInfo.alpha2)\","
            jsonTxt += "\"visits\":["
            for date in country.visits {
                jsonTxt += "\(date.timeIntervalSince1970),"
            }
            if country.visits.count > 0 { jsonTxt.removeLast() }
            jsonTxt += "]},"
        }
        if countries.count > 0 { jsonTxt.removeLast() }
        jsonTxt += "]"
        return jsonTxt
    }
    
    public static func visitsThisYearToUserDefaults(allVisits: Set<Country>) -> Void {
        let visitsThisYear : [Country] = visitsThisYear(allVisits: allVisits)
        let jsonTxt        : String = countriesToJson(countries: visitsThisYear)
        visitsThisYearToUserDefaults(jsonTxt: jsonTxt)
    }
    public static func visitsThisYearToUserDefaults(jsonTxt: String) -> Void {
        let jsonData = jsonTxt.data(using: .utf8)
        UserDefaults(suiteName: "group.eu.hansolo.ontravel")!.set(jsonData, forKey: Constants.VISITS_THIS_YEAR_KEY_UD)
    }
    public static func visitsThisYearFromUserDefaults() -> [Country] {
        var countries : [Country]    = []
        let encodedData = UserDefaults(suiteName: "group.eu.hansolo.ontravel")!.object(forKey: Constants.VISITS_THIS_YEAR_KEY_UD) as? Data
        if let jsonEncoded = encodedData {
            let jsonData  : [JsonData] = try! JSONDecoder().decode([JsonData].self, from: jsonEncoded)
            for jd in jsonData {
                let country : Country? = jd.getCountry()
                if nil != country { countries.append(country!) }
            }
        }
        return countries
    }
    
    public static func visitsThisMonthToUserDefaults(allVisits: Set<Country>) -> Void {
        let visitsThisMonth : [Country] = visitsThisMonth(allVisits: allVisits)
        let jsonTxt         : String = countriesToJson(countries: visitsThisMonth)
        visitsThisMonthToUserDefaults(jsonTxt: jsonTxt)
    }
    public static func visitsThisMonthToUserDefaults(jsonTxt: String) -> Void {
        let jsonData = jsonTxt.data(using: .utf8)
        UserDefaults(suiteName: "group.eu.hansolo.ontravel")!.set(jsonData, forKey: Constants.VISITS_THIS_MONTH_KEY_UD)
    }
    public static func visitsThisMonthFromUserDefaults() -> [Country] {
        var countries : [Country]    = []
        let encodedData = UserDefaults(suiteName: "group.eu.hansolo.ontravel")!.object(forKey: Constants.VISITS_THIS_MONTH_KEY_UD) as? Data
        if let jsonEncoded = encodedData {
            let jsonData  : [JsonData] = try! JSONDecoder().decode([JsonData].self, from: jsonEncoded)
            for jd in jsonData {
                let country : Country? = jd.getCountry()
                if nil != country { countries.append(country!) }
            }
        }
        return countries
    }
    
    public static func countriesFromVisits(visits: [Visit]) -> [Country] {
        var countries : [Country] = []
        for visit in visits {
            let isoInfo : IsoCountryInfo = IsoCountryCodes.find(key: visit.iso!)!
            let country : Country        = Country(isoInfo: isoInfo)
            countries.append(country)
        }
        return countries
    }
    
    public static func countriesToCsv(countries: [Country]) -> String {
        let dateFormatter : DateFormatter = DateFormatter(dateFormat: "dd/MM/yyyy", calendar: Calendar.current)
        var csvTxt        : String        = "\"iso\",\"name\",\"date\"\n"
        for country in countries {
            for date in country.visits {
                csvTxt += "\"\(country.isoInfo.alpha2)\",\"\(country.isoInfo.name)\",\"\(dateFormatter.string(from: date))\"\n"
            }
        }
        return csvTxt
    }
    
    public static func createCSV(year: Int) -> String {
        let json      : String    = readJson(year: year)
        let countries : [Country] = countriesFromJson(jsonTxt: json)
        let csv       : String    = countriesToCsv(countries: countries)
        return csv
    }
    
    public static func updateCurrencies(forceUpdate: Bool? = false) -> Void {
        Task {
            if forceUpdate! {
                let rates : [String:Double] = await RestController.getCurrencies()
                storeCurrenciesToUserDefaults(currencies: rates)
                debugPrint("Forced update of currencies and stored to properties")
            } else {
                let lastUpdate : Double = Properties.instance.lastCurrencyUpdate!
                let now        : Double = Date.init().timeIntervalSince1970
                let delta      : Double = now - lastUpdate
                if delta > Constants.SECONDS_24H {
                    let rates : [String:Double] = await RestController.getCurrencies()
                    storeCurrenciesToUserDefaults(currencies: rates)
                    debugPrint("Currencies updated and stored to properties")
                }
            }
        }
    }
        
    public static func getCurrencyRateString(homeCountry: IsoCountryInfo, currentCountry: IsoCountryInfo) -> String {
        if homeCountry.currency == currentCountry.currency { return "" }
        let currency   : String          = currentCountry.currency
        let currencies : [String:Double] = Helper.readCurrenciesFromUserDefaults()
        if currencies.isEmpty { return "" }
        let rate       : Double          = currencies[currency] ?? 1
        return "10 \(currency) -> \(String(format: "%.2f", (10.0 / rate))) \(homeCountry.currency)"
    }
    
    public static func storeCurrenciesToUserDefaults(currencies: [String:Double]) -> Void {
        let userDefaults = UserDefaults.standard        
        userDefaults.set(currencies, forKey: Constants.CURRENCIES_KEY_UD)
    }
    
    public static func readCurrenciesFromUserDefaults() -> [String:Double] {
        let userDefaults = UserDefaults.standard
        return (userDefaults.object(forKey: Constants.CURRENCIES_KEY_UD) as? [String:Double]) ?? [:]
    }
    
    public static func dateToString(fromDate date: Date, formatString: String) -> String {
        return dateToString(fromDate: date, formatString: formatString, timezone: TimeZone.current)
    }
    public static func dateToString(fromDate date: Date, formatString: String, timezoneIdentifier: String) -> String {
        return dateToString(fromDate: date, formatString: formatString, timezone: TimeZone(identifier: timezoneIdentifier) ?? .current)
    }
    public static func dateToString(fromDate date: Date, formatString: String, timezone: TimeZone) -> String {
        let dateFormatter        = DateFormatter()
        dateFormatter.timeZone   = timezone
        dateFormatter.dateFormat = formatString.isEmpty ? Constants.METRIC_DATE_TIME_FORMAT : formatString
        return dateFormatter.string(from: date)
    }
}
