//
//  LocationManager.swift
//  CountryCounter
//
//  Created by Gerrit Grunwald on 20.08.24.
//

import Foundation
import AudioToolbox
import CoreLocation
import Combine
import SwiftUI
import AVFoundation
import MapKit
import WidgetKit



class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var networkMonitor    : NetworkMonitor    = NetworkMonitor()
    @Published var locationStatus    : CLAuthorizationStatus?
    @Published var location          : CLLocation? {
        willSet {
            objectWillChange.send()
        }
        didSet {
            self.latitude                 = location?.coordinate.latitude  ?? 0.0
            self.longitude                = location?.coordinate.longitude ?? 0.0
            Properties.instance.lastLat   = self.latitude
            Properties.instance.lastLon   = self.longitude
            Properties.instance.timestamp = Date().timeIntervalSince1970
            self.lastLocation             = self.location
            self.timezone                 = TimeZone.current
            self.abbreviation             = self.timezone.abbreviation() ?? ""
            self.identifier               = self.timezone.identifier
            self.offsetFromGMT            = Double(self.timezone.secondsFromGMT())
            self.isDST                    = TimeZone.current.isDaylightSavingTime()
            
            DispatchQueue.main.async {
                let times         : Dictionary<String, Date> = self.magicHours.getTimes(date: Date.now, lat: self.latitude, lon: self.longitude)
                let dateFormatter : DateFormatter            = DateFormatter()
                
                dateFormatter.timeZone   = self.timezone
                dateFormatter.dateFormat = Constants.METRIC_TIME_FORMAT
                self.sunriseMetric       = dateFormatter.string(from: times["sunrise"]!)
                self.sunsetMetric        = dateFormatter.string(from: times["sunset"]!)
                
                dateFormatter.dateFormat = Constants.IMPERIAL_TIME_FORMAT
                self.sunriseImperial     = dateFormatter.string(from: times["sunrise"]!)
                self.sunsetImperial      = dateFormatter.string(from: times["sunset"]!)
            }
        }
    }
    @Published var lastLocation      : CLLocation?
    @Published var placemark         : CLPlacemark?
    @Published var latitude          : Double            = 0.0
    @Published var longitude         : Double            = 0.0
    @Published var storedProperties  : Bool              = false
    @Published var timezone          : TimeZone          = TimeZone.current
    @Published var abbreviation      : String            = TimeZone.current.abbreviation() ?? ""
    @Published var identifier        : String            = TimeZone.current.identifier
    @Published var offsetFromGMT     : Double            = Double(TimeZone.current.secondsFromGMT())    
    @Published var isDST             : Bool              = TimeZone.current.isDaylightSavingTime()
    @Published var magicHours        : MagicHours        = MagicHours()
    @Published var sunriseMetric     : String            = "-"
    @Published var sunsetMetric      : String            = "-"
    @Published var sunriseImperial   : String            = "-"
    @Published var sunsetImperial    : String            = "-"
        
    private    let locationManager   : CLLocationManager = CLLocationManager()
    private    let geocoder          : CLGeocoder        = CLGeocoder()
            
        
    override init() {
        super.init()
        
        locationManager.delegate                           = self
        locationManager.desiredAccuracy                    = kCLLocationAccuracyBest
        locationManager.distanceFilter                     = 10 // minimum movement in meter before location update
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.activityType                       = CLActivityType.otherNavigation
        locationManager.allowsBackgroundLocationUpdates    = true
        locationManager.showsBackgroundLocationIndicator   = true
    }
    
    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }
        
        switch status {
            case .notDetermined       : return "notDetermined"
            case .authorizedWhenInUse : return "authorizedWhenInUse"
            case .authorizedAlways    : return "authorizedAlways"
            case .restricted          : return "restricted"
            case .denied              : return "denied"
            default                   : return "unknown"
        }
    }
    
    
    public func startLocationUpdates() -> Void {
        /* Start location update only if online
        if !self.networkMonitor.online {
            debugPrint("Offline -> no location updates")
            return
        }
        */
        
        debugPrint("Start location updates")
        locationManager.allowsBackgroundLocationUpdates  = true
        locationManager.showsBackgroundLocationIndicator = true
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.startUpdatingHeading()
        locationManager.startMonitoringVisits()
    }
    
    public func stopLocationUpdates() -> Void {
        debugPrint("Stop location updates")
        locationManager.allowsBackgroundLocationUpdates  = false
        locationManager.showsBackgroundLocationIndicator = false
        locationManager.stopUpdatingLocation()
        locationManager.stopMonitoringSignificantLocationChanges()
        locationManager.stopUpdatingHeading()
        locationManager.stopMonitoringVisits()
    }
            
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {        
        guard let currentLocation = locations.first else { return }
        self.location = currentLocation
                                
        // Avoid update country when altitude > 6000m or speed > 300 kph (usually when on a plane)
        if self.location?.altitude ?? 0 > Constants.ALTITUDE_LIMIT || self.location?.speed ?? 0 > Constants.SPEED_LIMIT {
            self.stopLocationUpdates()
            return
        }
        
        self.geocode() { placemark, error in
            guard let placemark = placemark, error == nil else {
                debugPrint("Error while geocding location. Error: \(String(describing: error?.localizedDescription))")
                return
            }
            if nil != placemark.isoCountryCode {
                self.placemark = placemark
                
                let now            : Date           = Date.init()
                let year           : Int            = Calendar.current.component(.year, from: now)
                let isoCountryCode : String         = placemark.isoCountryCode ?? ""
                let flag           : String         = IsoCountryCodes.find(key: isoCountryCode)?.flag ?? ""
                let isoInfo        : IsoCountryInfo = IsoCountryCodes.find(key: isoCountryCode)!
                
                if Properties.instance.country != isoCountryCode {
                    Task {
                        let holidays : [Holidays]? = await RestController.getPublicHolidays(countryInfo: isoInfo)
                        if nil != holidays {
                            let dateFormatter : DateFormatter = DateFormatter()
                            dateFormatter.dateFormat = Constants.PUBLIC_HOLIDAY_DATE_FORMAT
                            Properties.instance.holidays!.removeAll()
                            for holiday in holidays! {
                                let date : Date? = dateFormatter.date(from: holiday.start!)
                                if nil != date {
                                    Properties.instance.holidays!.append(date!)
                                }
                            }
                        }
                    }
                }
                
                Properties.instance.country   = isoCountryCode
                Properties.instance.flag      = flag
                Properties.instance.timestamp = now.timeIntervalSince1970
                
                // Create json file if not present
                if Helper.jsonExists(year: year) {
                    let json : String = Helper.readJson(year: year)
                    if json.isEmpty {
                        DispatchQueue.global().async {
                            let country : Country = Country(isoInfo: isoInfo)
                            _ = country.addVisit(date: now)
                            var jsonTxt : String = "["
                            jsonTxt += "{ \"iso\":\"\(country.isoInfo.alpha2)\","
                            jsonTxt += "\"visits\":["
                            for date in country.visits {
                                jsonTxt += "\(date.timeIntervalSince1970),"
                            }
                            jsonTxt += "]}]"
                            Helper.saveJson(json: jsonTxt)
                            Helper.visitsThisMonthToUserDefaults(jsonTxt: jsonTxt)
                            Helper.visitsThisYearToUserDefaults(jsonTxt: jsonTxt)
                        }
                        debugPrint("Json file exists, but was empty -> saved new json file in LocationManager")
                    } else {
                        DispatchQueue.global().async {                            
                            // Update json file
                            var allVisits : Set<Country> = Set<Country>()
                            let countries : [Country]    = Helper.countriesFromJson(jsonTxt: json)
                            for country in countries { allVisits.insert(country) }
                            
                            let countryFound   : Country? = allVisits.filter{ $0.isoInfo.name == isoInfo.name }.first
                            var needsToBeSaved : Bool = true
                            if countryFound == nil {
                                // No country found -> create new country and save it to json file
                                let country : Country = Country(isoInfo: isoInfo)
                                _ = country.addVisit(date: now)
                                allVisits.insert(country)
                            } else {
                                // Country found, add visit to country if not already present
                                needsToBeSaved = countryFound!.addVisit(date: now)
                            }
                            
                            if needsToBeSaved {
                                // Only save json file if needed
                                let jsonTxt : String = Helper.visitsToJson(allVisits: allVisits)
                                Helper.saveJson(json: jsonTxt)
                                debugPrint("Json file exists -> updated visits and saved json file in LocationManager")
                                Helper.updateCurrencies(forceUpdate: false)
                            } else {
                                debugPrint("No changes -> saving json file not needed")
                            }
                            Helper.visitsThisMonthToUserDefaults(allVisits: allVisits)
                            Helper.visitsThisYearToUserDefaults(allVisits: allVisits)
                        }
                    }
                } else {
                    DispatchQueue.global().async {
                        let country : Country = Country(isoInfo: isoInfo)
                        _ = country.addVisit(date: now)
                        var jsonTxt : String = "["
                        jsonTxt += "{ \"iso\":\"\(country.isoInfo.alpha2)\","
                        jsonTxt += "\"visits\":["
                        for date in country.visits {
                            jsonTxt += "\(date.timeIntervalSince1970),"
                        }
                        jsonTxt += "]}]"
                        
                        Helper.saveJson(json: jsonTxt)
                        debugPrint("Json file did not exists -> saved new json file in LocationManager")
                        Helper.updateCurrencies(forceUpdate: false)
                        
                        Helper.visitsThisMonthToUserDefaults(jsonTxt: jsonTxt)
                        Helper.visitsThisYearToUserDefaults(jsonTxt: jsonTxt)
                    }
                }
                //debugPrint("Stored flag, country and timestamp for \(flag) \(isoCountryCode) to properties")
                self.storedProperties.toggle()
                WidgetCenter.shared.reloadAllTimelines()
                self.stopLocationUpdates()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle error here
    }
            
    func getCurrentCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
    
    public func geocode(completion: @escaping (CLPlacemark?, Error?) -> ())  {
        geocoder.reverseGeocodeLocation(CLLocation(latitude: self.latitude, longitude: self.longitude)) { completion($0?.first, $1) }
    }
    
    public func geocodeAsync() async throws -> [CLPlacemark?] {
        if nil == self.location { return [] }
        return try await geocoder.reverseGeocodeLocation(self.location!)
    }            
}
