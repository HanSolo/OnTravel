//
//  ContentView.swift
//  OnTravel
//
//  Created by Gerrit Grunwald on 24.08.24.
//

import SwiftUI
import Combine
import CoreLocation


struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject private var model               : OnTravelModel
    @EnvironmentObject private var locationManager     : LocationManager
    @State             private var name                : String = ""
    @State             private var flag                : String = ""
    @State             private var isoInfo             : IsoCountryInfo?
    @State             private var refreshCalendarView : Bool = false
    
    
    var body: some View {
        VStack {
            HStack(spacing: 5) {
                Text(self.flag)
                    .font(.system(size: 36))
                Text(self.name)
                    .font(.system(size: 20))
            }
            Text("Remaining days: \(self.model.remainingDays)")
                .font(.system(size: 16))
            .task {
                updateFlag()
            }
            .onChange(of: self.locationManager.location) {
                updateFlag()
            }
            /*
            .onChange(of: scenePhase) { (newPhase, error) in
                if newPhase == .inactive {
                    print("newPhase == .inactive")
                } else if newPhase == .active {
                    print("newPhase == .active")
                } else if newPhase == .background {
                    print("newPhase == .background")
                }
            }
            */
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { (_) in
                // Update remaining days
                self.model.remainingDays = Calendar.current.dateComponents([.day], from: Date.init(), to: Helper.getLastDayOfYear()).day!
                
                // Update model with saved data
                if self.model.allVisits.isEmpty {
                    let json      : String    = Helper.readJson(year: Calendar.current.component(.year, from: Date.init()))
                    let countries : [Country] = Helper.getCountriesFromJson(json: json)
                    for country in countries { self.model.allVisits.insert(country) }
                }
                updateFlag()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { (_) in
                Properties.instance.lastLat = self.locationManager.latitude
                Properties.instance.lastLon = self.locationManager.longitude
                OnTravel.AppDelegate.instance.scheduleAppProcessing()
            }
            List {
                if !self.model.allVisits.isEmpty {
                    ForEach(Array(self.model.allVisits)) { country in
                        HStack {
                            Text(country.isoInfo.flag ?? "")
                                .font(.system(size: 24))
                            Text(country.isoInfo.name)
                                .font(.system(size: 13))
                            Spacer()
                            Text("\(country.getAllVisits())")
                                .font(.system(size: 13)).multilineTextAlignment(.trailing)
                        }
                    }
                }
            }
            CalendarView(calendar: Calendar.current)
                .id(self.refreshCalendarView)
        }
    }
    
    
    private func updateFlag() -> Void {
        // Avoid update country when on a plane 
        if self.locationManager.location?.altitude ?? 0 > 4000 && self.locationManager.location?.speed ?? 0 > 250 { return }
        locationManager.geocode() { placemark, error in
            guard let placemark = placemark, error == nil else { return }
            DispatchQueue.main.async {
                if nil != placemark.isoCountryCode {
                    Properties.instance.country = placemark.isoCountryCode
                    self.isoInfo = IsoCountryCodes.find(key: placemark.isoCountryCode ?? "")
                    if nil != isoInfo {
                        let now : Date = Date.init()
                        self.flag = isoInfo!.flag ?? ""
                        self.name = isoInfo!.name
                        
                        let countryFound : Country? = self.model.allVisits.filter{ $0.isoInfo.name == isoInfo!.name }.first
                        if countryFound == nil {
                            let country : Country = Country(isoInfo: isoInfo!)
                            country.addVisit(date: now)
                            self.model.allVisits.insert(country)
                        } else {
                            countryFound!.addVisit(date: now)
                        }
                        self.refreshCalendarView.toggle()
                        
                        let year : Int = Calendar.current.component(.year, from: Date())
                        if let firstOfNextYear : Date = Calendar.current.date(from: DateComponents(year: year + 1, month: 1, day: 1)) {
                            let lastOfYear : Date = Calendar.current.date(byAdding: .day, value: -1, to: firstOfNextYear)!
                            let now        : Date = Date.init()
                            self.model.remainingDays = Calendar.current.daysBetween(from: now, to: lastOfYear)
                        }
                        Helper.saveJson(json: self.model.toJson())
                        self.locationManager.stopLocationUpdates()
                    }
                }
            }
        }
    }
    
    private func resetVisits() -> Void {
        self.model.allVisits.removeAll()
    }
}
