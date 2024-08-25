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


class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate { //}, BackgroundTimerDelegate  {
    @Published var locationStatus : CLAuthorizationStatus?
    @Published var location       : CLLocation? {
        willSet {
            objectWillChange.send()
        }
        didSet {
            self.latitude                     = location?.coordinate.latitude  ?? 0.0
            self.longitude                    = location?.coordinate.longitude ?? 0.0
            Properties.instance.lastLat       = self.latitude
            Properties.instance.lastLon       = self.longitude
            Properties.instance.lastTimestamp = Date().timeIntervalSince1970
            self.lastLocation                 = self.location
        }
    }
    @Published var lastLocation   : CLLocation?
    @Published var latitude       : Double                   = 0.0
    @Published var longitude      : Double                   = 0.0
    @Published var placemark      : CLPlacemark?
        
    private      let locationManager : CLLocationManager = CLLocationManager()
    private      let geocoder        : CLGeocoder        = CLGeocoder()
    
    private      var tasks           : [UIBackgroundTaskIdentifier] = []
    //private lazy var timer           : BackgroundTimer              = BackgroundTimer(delegate: self)
    
    
    override init() {
        super.init()
          
        locationManager.delegate                           = self
        locationManager.desiredAccuracy                    = kCLLocationAccuracyBest
        locationManager.distanceFilter                     = 10 // minimum movement in meter before location update
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.activityType                       = CLActivityType.otherNavigation
        locationManager.allowsBackgroundLocationUpdates    = true
        locationManager.showsBackgroundLocationIndicator   = true
        
        
        /*
        let taskID = timer.executeAfterDelay(delay: TimeInterval(Constants.TIMER_INTERVAL_IN_SECONDS), repeating: true) {
            self.startLocationUpdates()
        }
        tasks += [taskID]
        */
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
    
    
    /*
    func backgroundTimerTaskExecuted(task: UIBackgroundTaskIdentifier, willRepeat: Bool) {
        guard !willRepeat else {
            return
        }
        
        guard let row = tasks.firstIndex(of: task) else {
            return assertionFailure()
        }
        
        tasks.remove(at: row)
    }
    
    func backgroundTimerTaskCanceled(task: UIBackgroundTaskIdentifier) {
    }
    */
}
