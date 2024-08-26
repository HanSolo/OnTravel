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
    @State             private var refreshCalendarView : Bool   = false
    @State             private var showingExporter     : Bool   = false
    @State             private var selectedYear        : Int    = Calendar.current.component(.year, from: Date.init())
    @State             private var isoInfo             : IsoCountryInfo?
    
    
    var body: some View {
        VStack(spacing: 5) {
            HStack(spacing: 5) {
                Picker("Year", selection: self.$selectedYear) {
                    ForEach(self.model.availableYears, id: \.self) { year in
                        Text("\(year, format: .number.grouping(.never))")
                    }
                }
                Spacer()
                Text("On Travel")
                    .font(.system(size: 36))
                Spacer()
                Button(action: {
                    self.showingExporter = true
                }, label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 14))
                        .foregroundColor(.accentColor)
                })
            }
            .padding()
            HStack(spacing: 5) {
                Spacer()
                Text(self.flag)
                    .font(.system(size: 36))
                Text(self.name)
                    .font(.system(size: 20))
                Spacer()
            }
            Text("\(self.model.remainingDays) remaining days in \(Calendar.current.component(.year, from: Date.init()), format: .number.grouping(.never))")
                .font(.system(size: 14))
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
        .task {
            updateCountry()
        }
        .onChange(of: self.locationManager.location) {
            updateCountry()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { (_) in
            // Update remaining days
            self.model.remainingDays = Calendar.current.dateComponents([.day], from: Date.init(), to: Helper.getLastDayOfYear()).day!
            
            // Update model with saved data
            if self.model.allVisits.isEmpty {
                let json      : String    = Helper.readJson(year: Calendar.current.component(.year, from: Date.init()))
                let countries : [Country] = Helper.getCountriesFromJson(json: json)
                for country in countries { self.model.allVisits.insert(country) }
            }            
            
            updateCountry()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { (_) in
            Properties.instance.lastLat = self.locationManager.latitude
            Properties.instance.lastLon = self.locationManager.longitude
            OnTravel.AppDelegate.instance.scheduleAppProcessing()
        }
        .fileExporter(isPresented: $showingExporter, document: TextFile(initialText: Helper.createCSV(year: self.selectedYear), year: self.selectedYear), contentType: .plainText) { result in
            switch result {
                case .success(let url):
                    print("Saved to \(url)")
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    
    private func updateCountry() -> Void {
        // Avoid update country when on a plane
        if self.locationManager.location?.altitude ?? 0 > 4000 && self.locationManager.location?.speed ?? 0 > 250 { return }
        print("ContentView.updateCountry")
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
                        
                        self.model.remainingDays = Calendar.current.dateComponents([.day], from: now, to: Helper.getLastDayOfYear()).day!
                        
                        DispatchQueue.global().async {
                            Helper.saveJson(json: self.model.toJson())
                        }
                        self.locationManager.stopLocationUpdates()
                    }
                }
            }
        }
    }
    
    private func updateCountryFromProperties() -> Void {
        DispatchQueue.main.async {
            let lastCountry : String = Properties.instance.country!
            let timestamp   : Date   = Date.init(timeIntervalSinceReferenceDate: Properties.instance.timestamp!)
            if !lastCountry.isEmpty {
                self.isoInfo = IsoCountryCodes.find(key: lastCountry)
                if nil != isoInfo {
                    self.flag = isoInfo!.flag ?? ""
                    self.name = isoInfo!.name
                    
                    let countryFound : Country? = self.model.allVisits.filter{ $0.isoInfo.name == isoInfo!.name }.first
                    if countryFound == nil {
                        let country : Country = Country(isoInfo: isoInfo!)
                        country.addVisit(date: timestamp)
                        self.model.allVisits.insert(country)
                    } else {
                        countryFound!.addVisit(date: timestamp)
                    }
                    self.refreshCalendarView.toggle()

                    DispatchQueue.global().async {
                        Helper.saveJson(json: self.model.toJson())
                    }
                }
            }
        }
    }
    
    private func resetVisits() -> Void {
        self.model.allVisits.removeAll()
    }
}
