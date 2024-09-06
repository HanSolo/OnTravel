//
//  ContentView.swift
//  OnTravel
//
//  Created by Gerrit Grunwald on 24.08.24.
//

import SwiftUI
import Combine
import CoreLocation
import SVGView
import WidgetKit


struct ContentView: View {
    @Environment(\.dismiss)      var dismiss
    @Environment(\.displayScale) var displayScale
    @EnvironmentObject   private var model               : OnTravelModel
    @EnvironmentObject   private var locationManager     : LocationManager
    @State               private var name                : String              = ""
    @State               private var flag                : String              = ""
    @State               private var refreshCalendarView : Bool                = false
    @State               private var showingExporter     : Bool                = false
    @State               private var selectedYear        : Int                 = Calendar.current.component(.year, from: Date.init())
    @State               private var isoInfo             : IsoCountryInfo?
    @State               private var year                : Int                 = Calendar.current.component(.year, from: Date.init())
    @State               private var settingsVisible     : Bool                = false
    @State               private var chartVisible        : Bool                = false
            
    
    var body: some View {
        
        ViewThatFits {
            ScrollView {
                VStack(spacing: 5) {
                    HStack(spacing: 5) {
                        Text("OFFLINE")
                            .font(.system(size: 8))
                            .padding(EdgeInsets(top: 2, leading: 5, bottom: 2, trailing: 5))
                            .foregroundStyle(.white)
                            .background(
                                ZStack {
                                    RoundedRectangle(
                                        cornerRadius: 5,
                                        style       : .continuous
                                    )
                                    .fill(.red)
                                    RoundedRectangle(
                                        cornerRadius: 5,
                                        style       : .continuous
                                    )
                                    .stroke(.red, lineWidth: 1)
                                }
                            )
                            .opacity(self.locationManager.networkMonitor.online ? 0.0 : 1.0)
                        Spacer()
                        HStack {
                            if let image = UIImage(named: AppIconProvider.appIcon()) {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(RoundedRectangle(cornerRadius: 3))
                                    .frame(width: 20, height: 20)
                            }
                            Text("On Travel")
                                .font(.system(size: 20))
                        }
                        Spacer()
                        Menu {
                            Picker("Year for export", selection: self.$selectedYear) {
                                ForEach(self.model.availableYears, id: \.self) { year in
                                    Text("\(year, format: .number.grouping(.never))")
                                }
                            }.pickerStyle(.menu)
                            
                            Button(action: {
                                self.showingExporter = true
                            }, label: {
                                HStack {
                                    Image(systemName: "square.and.arrow.up")
                                    Text("Export to CSV")
                                }
                            })
                                                        
                            Button(action: {
                                self.chartVisible.toggle()
                            }, label: {
                                HStack {
                                    Image(systemName: "chart.pie.fill")
                                    Text("Show chart")
                                }
                            })                            
                            
                            Button(action: {
                                self.settingsVisible.toggle()
                            }) {
                                HStack {
                                    Image(systemName: "gear")
                                    Text("Settings")
                                }
                            }
                                        
                        } label: {
                            Image(systemName: "line.3.horizontal")
                                .font(.system(size: 24))
                        }
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
                    Text("You've been to \(self.model.allVisits.count) \(self.model.allVisits.count < 2 ? "country" : "countries") in \(self.year, format: .number.grouping(.never))")
                        .font(.system(size: 16))
                    Text("(\(self.model.remainingDays) remaining days)")
                        .font(.system(size: 14))
                    List {
                        Section {
                            if self.model.ignoreHomeCountry {
                                if !self.model.allVisitsWithoutHome.isEmpty {
                                    let sorted = Array(self.model.allVisitsWithoutHome).sorted(by: { lhs, rhs in
                                        return rhs.visits.count < lhs.visits.count
                                    })
                                    ForEach(Array(sorted)) { country in
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
                            } else {
                                if !self.model.allVisits.isEmpty {
                                    let sorted = Array(self.model.allVisits).sorted(by: { lhs, rhs in
                                        return rhs.visits.count < lhs.visits.count
                                    })
                                    ForEach(Array(sorted)) { country in
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
                        }
                        .listSectionSeparator(.visible)
                    }
                    .contentMargins(.top, 5, for: .scrollContent)
                    .contentMargins(.trailing, 5, for: .scrollContent)
                    .contentMargins(.bottom, 5, for: .scrollContent)
                    .contentMargins(.leading, 5, for: .scrollContent)
                    .frame(minHeight: 250)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    
                    CalendarView(calendar: Calendar.current)
                        .id(self.refreshCalendarView)
                    
                    MapView()
                        .frame(width: 360, height: 237)
                }
            }
            .task {             
                WidgetCenter.shared.reloadAllTimelines()
            }
            .onChange(of: self.locationManager.storedProperties) {
                updateCountryFromProperties()
            }
            .onChange(of: self.model.allVisits) {
                refreshCalendarView.toggle()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { (_) in
                // Start location updates
                self.locationManager.startLocationUpdates()
                
                // Update remaining days
                self.model.remainingDays = Calendar.current.dateComponents([.day], from: Date.init(), to: Helper.lastDayOfYear()).day!
                
                // Update model with saved data
                if self.model.allVisits.isEmpty {
                    //Swift.debugPrint("AllVisits in model is empty -> load from json file")
                    if Helper.jsonExists(year: self.year) {
                        let json : String = Helper.readJson(year: self.year)
                        if json.isEmpty {
                            //Swift.debugPrint("Json file present but empty, create new one")
                            let isoCode : String = Properties.instance.country!
                            if !isoCode.isEmpty {
                                let isoInfo : IsoCountryInfo = IsoCountryCodes.find(key: isoCode)!
                                let now     : Date           = Date.init()
                                let country : Country        = Country(isoInfo: isoInfo)
                                country.addVisit(date: now)
                                self.model.allVisits.insert(country)
                                self.flag = isoInfo.flag ?? ""
                                self.name = isoInfo.name
                            }
                        } else {
                            let countries : [Country] = Helper.countriesFromJson(jsonTxt: json)
                            for country in countries { self.model.allVisits.insert(country) }
                            //Swift.debugPrint("Loaded allVisits from json in ContentView")
                        }
                    } else {
                        //Swift.debugPrint("json file does not exists when try to read in ContentView")
                    }
                }
                
                WidgetCenter.shared.reloadAllTimelines()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { (_) in                
                OnTravel.AppDelegate.instance.scheduleAppProcessing()
            }
            .fileExporter(isPresented: $showingExporter, document: TextFile(initialText: Helper.createCSV(year: self.selectedYear), year: self.selectedYear), contentType: .plainText) { result in
                switch result {
                case .success(let url):
                    Swift.debugPrint("Saved to \(url)")
                case .failure(let error):
                    Swift.debugPrint("Error: \(error.localizedDescription)")
                }
            }            
            .sheet(isPresented: self.$settingsVisible, content: {
                SettingsView()
            })
            .sheet(isPresented: self.$chartVisible, content: {                
                PiechartView()
            })
        }
    }

    
    private func updateCountryFromProperties() -> Void {
        // Avoid update country when altitude > 6000m or speed > 300 kph (usually when on a plane)
        if self.locationManager.location?.altitude ?? 0 > Constants.ALTITUDE_LIMIT || self.locationManager.location?.speed ?? 0 > Constants.SPEED_LIMIT { return }
        DispatchQueue.main.async {
            let country : String = Properties.instance.country!
            let now     : Date   = Date.init(timeIntervalSince1970: Properties.instance.timestamp!)            
            if !country.isEmpty {
                self.isoInfo = IsoCountryCodes.find(key: country)
                if nil != isoInfo {
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
                    
                    self.model.remainingDays  = Calendar.current.dateComponents([.day], from: now, to: Helper.lastDayOfYear()).day!
                    self.model.availableYears = Helper.availableYears()
                }
            }
        }
    }
}
