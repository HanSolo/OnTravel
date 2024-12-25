//
//  OnTravelApp.swift
//  OnTravel
//
//  Created by Gerrit Grunwald on 24.08.24.
//

import SwiftUI


@main
struct CountryCounterApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    
    var body: some Scene {
        
        WindowGroup {
            ContentView().environmentObject(appDelegate.model)
                         .environmentObject(appDelegate.locationManager)
        }
    }
}

