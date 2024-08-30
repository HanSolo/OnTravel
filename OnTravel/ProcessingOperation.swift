//
//  ProcessingOperation.swift
//  CountryCounter
//
//  Created by Gerrit Grunwald on 23.08.24.
//

import Foundation
import UserNotifications


class ProcessingOperation: Operation {
    let locationManager : LocationManager?
    let model           : OnTravelModel?
    
    init(locationManager: LocationManager?, model: OnTravelModel?) {
        self.locationManager = locationManager
        self.model           = model
    }
    
    override func main() {
        if isCancelled {
            return
        }
        Swift.debugPrint("main -> start location updates from background task")
        if nil != self.locationManager {
            self.locationManager?.startLocationUpdates()
        }
    }
}
