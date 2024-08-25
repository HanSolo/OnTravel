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
    
    init(_ locationManager: LocationManager?) {
        self.locationManager = locationManager
    }
    
    override func main() {
        if isCancelled {
            return
        }
        print("main -> update model from background task (processing)")
        if nil != self.locationManager {
            self.locationManager?.startLocationUpdates()
        }
    }
}
