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
                
        self.locationManager.startLocationUpdates()
                
        registerBackgroundTasks()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        Swift.debugPrint("applicationDidBecomeActive")
        self.locationManager.startLocationUpdates()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        Swift.debugPrint("applicationDidEnterBackground")
        Properties.instance.lastLat = self.locationManager.latitude
        Properties.instance.lastLon = self.locationManager.longitude
        self.locationManager.stopLocationUpdates()
        scheduleAppProcessing()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        Swift.debugPrint("applicationWillTerminate")
        Properties.instance.lastLat = self.locationManager.latitude
        Properties.instance.lastLon = self.locationManager.longitude
        self.locationManager.stopLocationUpdates()
        scheduleAppProcessing()
    }
    
    
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

