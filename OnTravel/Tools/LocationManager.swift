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


class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var locationStatus   : CLAuthorizationStatus?
    @Published var location         : CLLocation? {
        willSet {
            objectWillChange.send()
        }
        didSet {
            self.latitude                     = location?.coordinate.latitude  ?? 0.0
            self.longitude                    = location?.coordinate.longitude ?? 0.0
            Properties.instance.lastLat       = self.latitude
            Properties.instance.lastLon       = self.longitude
            Properties.instance.timestamp = Date().timeIntervalSince1970
            self.lastLocation                 = self.location
        }
    }
    @Published var lastLocation     : CLLocation?
    @Published var placemark        : CLPlacemark?
    @Published var latitude         : Double            = 0.0
    @Published var longitude        : Double            = 0.0
    @Published var storedProperties : Bool              = false
        
    private    let locationManager  : CLLocationManager = CLLocationManager()
    private    let geocoder         : CLGeocoder        = CLGeocoder()
    
    
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
        
        self.geocode() { placemark, error in
            guard let placemark = placemark, error == nil else {
                Swift.debugPrint("Error while geocding location. Error: \(String(describing: error?.localizedDescription))")
                return
            }
            if nil != placemark.isoCountryCode {
                let now            : Date     = Date.init()
                let year           : Int      = Calendar.current.component(.year, from: now)
                let isoCountryCode : String   = placemark.isoCountryCode ?? ""
                let flag           : String   = IsoCountryCodes.find(key: isoCountryCode)?.flag ?? ""
                Properties.instance.country   = isoCountryCode
                Properties.instance.flag      = flag
                Properties.instance.timestamp = now.timeIntervalSince1970
                
                let isoInfo : IsoCountryInfo = IsoCountryCodes.find(key: placemark.isoCountryCode ?? "")!
                
                // Create json file if not present
                if Helper.jsonExists(year: year) {
                    let json : String = Helper.readJson(year: year)
                    if json.isEmpty {
                        DispatchQueue.global().async {
                            let country : Country = Country(isoInfo: isoInfo)
                            country.addVisit(date: now)
                            var jsonTxt : String = "["
                            jsonTxt += "{ \"iso\":\"\(country.isoInfo.alpha2)\","
                            jsonTxt += "\"visits\":["
                            for date in country.visits {
                                jsonTxt += "\(date.timeIntervalSince1970),"
                            }
                            jsonTxt += "]}]"
                            DispatchQueue.global().async {
                                Helper.saveJson(json: jsonTxt)
                            }
                        }
                        print("Json file exists, but was empty -> saved new json file in LocationManager")
                    } else {
                        DispatchQueue.global().async {
                            // Update json file
                            var allVisits : Set<Country> = Set<Country>()
                            let countries : [Country]    = Helper.getCountriesFromJson(json: json)
                            for country in countries { allVisits.insert(country) }
                            
                            let countryFound : Country? = allVisits.filter{ $0.isoInfo.name == isoInfo.name }.first
                            if countryFound == nil {
                                let country : Country = Country(isoInfo: isoInfo)
                                country.addVisit(date: now)
                                allVisits.insert(country)
                            } else {
                                countryFound!.addVisit(date: now)
                            }
                            DispatchQueue.global().async {
                                Helper.saveJson(json: Helper.visitsToJson(allVisits: allVisits))
                                print("Json file exists -> updated visits and saved json file in LocationManager")
                            }
                        }
                    }
                } else {
                    DispatchQueue.global().async {
                        let country : Country = Country(isoInfo: isoInfo)
                        country.addVisit(date: now)
                        var jsonTxt : String = "["
                        jsonTxt += "{ \"iso\":\"\(country.isoInfo.alpha2)\","
                        jsonTxt += "\"visits\":["
                        for date in country.visits {
                            jsonTxt += "\(date.timeIntervalSince1970),"
                        }
                        jsonTxt += "]}]"
                        DispatchQueue.global().async {
                            Helper.saveJson(json: jsonTxt)
                            print("Json file did not exists -> saved new json file in LocationManager")
                        }
                    }
                }
                //print("Stored flag, country and timestamp for \(flag) \(isoCountryCode) to properties")
                self.storedProperties.toggle()
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
