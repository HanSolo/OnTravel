//
//  AppDelegate.swift
//  OnTravel
//
//  Created by Gerrit Grunwald on 24.08.24.
//

import Foundation
import UIKit
import CoreLocation
import BackgroundTasks


class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    static private(set) var instance: AppDelegate! = nil
    
    let locationManager : LocationManager = LocationManager()
    let model           : OnTravelModel   = OnTravelModel()
        
            
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Code to be executed after app finished launching with options
        AppDelegate.instance = self
        
        let now  : Date = Date.init()
        let year : Int  = Calendar.current.component(.year, from: now)
        if Helper.jsonExists(year: year) {
            let json : String = Helper.readJson(year: year)
            if !json.isEmpty {
                let countries : [Country] = Helper.countriesFromJson(jsonTxt: json)
                for country in countries { self.model.allVisits.insert(country) }
                Swift.debugPrint("Loaded allVisits from json at startup in AppDelegate")
            }
        }
        
        self.locationManager.startLocationUpdates()
                
        registerBackgroundTasks()
        
        return true
    }
    
    /*
    func applicationDidBecomeActive(_ application: UIApplication) {
        Swift.debugPrint("applicationDidBecomeActive")
        self.locationManager.startLocationUpdates()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        Swift.debugPrint("applicationDidEnterBackground")
        self.locationManager.stopLocationUpdates()
        scheduleAppProcessing()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        Swift.debugPrint("applicationWillTerminate")
        self.locationManager.stopLocationUpdates()
        scheduleAppProcessing()
    }
    */
    
    
    private func registerBackgroundTasks() -> Void {
        Swift.debugPrint("registerBackgroundTasks")
        BGTaskScheduler.shared.register(forTaskWithIdentifier: Constants.PROCESSING_TASK_REQUEST_ID, using: nil) { task in
            task.setTaskCompleted(success: true)
            self.handleAppProcessing(task: task as! BGProcessingTask)
        }
    }
    
    
    func scheduleAppProcessing() {
        Swift.debugPrint("scheduleAppProcessing")
        let request = BGProcessingTaskRequest(identifier: Constants.PROCESSING_TASK_REQUEST_ID)
        request.requiresExternalPower       = false
        request.requiresNetworkConnectivity = false
        request.earliestBeginDate           = Date(timeIntervalSinceNow: Constants.PROCESSING_INTERVAL)
        
        BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: Constants.PROCESSING_TASK_REQUEST_ID)
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            Swift.debugPrint("scheduleAppProcessing. Error: \(error.localizedDescription)")
        }
    }
    
    func handleAppProcessing(task: BGProcessingTask) {
        Swift.debugPrint("handleAppRefresh")
        DispatchQueue.global().async {
            self.locationManager.startLocationUpdates()
            
            let taskID = UIApplication.shared.beginBackgroundTask(withName: Constants.PROCESSING_TASK_ID, expirationHandler: ({}))
            let queue  = OperationQueue()
            queue.maxConcurrentOperationCount = 1
                    
            let processingOperation = ProcessingOperation(locationManager: self.locationManager, model: self.model)
            queue.addOperation(processingOperation)
            task.expirationHandler = {
                task.setTaskCompleted(success: false)
            }
            
            let lastOperation = queue.operations.last
            lastOperation?.completionBlock = {
                task.setTaskCompleted(success: !(lastOperation?.isCancelled ?? false))
            }
            UIApplication.shared.endBackgroundTask(taskID)
        }
        
        scheduleAppProcessing()
    }
}

