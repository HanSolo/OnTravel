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
        
        let json      : String    = Helper.readJson(year: Calendar.current.component(.year, from: Date.init()))
        let countries : [Country] = Helper.getCountriesFromJson(json: json)
        for country in countries { self.model.allVisits.insert(country) }
        
        self.locationManager.startLocationUpdates()
                
        registerBackgroundTasks()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("applicationDidBecomeActive")
        self.locationManager.startLocationUpdates()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("applicationDidEnterBackground")
        Properties.instance.lastLat = self.locationManager.latitude
        Properties.instance.lastLon = self.locationManager.longitude
        self.locationManager.stopLocationUpdates()
        scheduleAppProcessing()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("applicationWillTerminate")
        Properties.instance.lastLat = self.locationManager.latitude
        Properties.instance.lastLon = self.locationManager.longitude
        self.locationManager.stopLocationUpdates()
        scheduleAppProcessing()
    }
    
    
    private func registerBackgroundTasks() -> Void {
        print("registerBackgroundTasks")
        BGTaskScheduler.shared.register(forTaskWithIdentifier: Constants.PROCESSING_TASK_REQUEST_ID, using: nil) { task in
            self.handleAppProcessing(task: task as! BGProcessingTask)
        }
    }
    
    
    func scheduleAppProcessing() {
        print("scheduleAppProcessing")
        let request = BGProcessingTaskRequest(identifier: Constants.PROCESSING_TASK_REQUEST_ID)
        request.requiresExternalPower       = false
        request.requiresNetworkConnectivity = true
        request.earliestBeginDate           = Date(timeIntervalSinceNow: Constants.PROCESSING_INTERVAL)
        
        BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: Constants.PROCESSING_TASK_REQUEST_ID)
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("scheduleAppProcessing -> error: \(error.localizedDescription)")
        }
    }
    
    func handleAppProcessing(task: BGProcessingTask) {
        print("handleAppRefresh")
        self.locationManager.startLocationUpdates()
        DispatchQueue.global().async {
            let taskID = UIApplication.shared.beginBackgroundTask(withName: Constants.PROCESSING_TASK_ID, expirationHandler: ({}))
            let queue  = OperationQueue()
            queue.maxConcurrentOperationCount = 1
                    
            let processingOperation = ProcessingOperation(self.locationManager)
            queue.addOperation(processingOperation)
            /*
            task.expirationHandler = {
                queue.cancelAllOperations()
            }
            */
            task.expirationHandler = {
                task.setTaskCompleted(success: false)
                /*
                if nil != processingOperation.session {
                    processingOperation.session!.invalidateAndCancel()
                }
                */
            }
            
            let lastOperation = queue.operations.last
            lastOperation?.completionBlock = {
                task.setTaskCompleted(success: !(lastOperation?.isCancelled ?? false))
                /*
                if let processingOperation = lastOperation as? ProcessingOperation {
                    processingOperation.session?.finishTasksAndInvalidate()
                }
                 */
            }
            UIApplication.shared.endBackgroundTask(taskID)
        }
        
        scheduleAppProcessing()
    }
}

