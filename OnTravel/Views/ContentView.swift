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


struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject private var model               : OnTravelModel
    @EnvironmentObject private var locationManager     : LocationManager
    @State             private var name                : String              = ""
    @State             private var flag                : String              = ""
    @State             private var refreshCalendarView : Bool                = false
    @State             private var showingExporter     : Bool                = false
    @State             private var selectedYear        : Int                 = Calendar.current.component(.year, from: Date.init())
    @State             private var isoInfo             : IsoCountryInfo?
    @State             private var year                : Int                 = Calendar.current.component(.year, from: Date.init())
    @State             private var orientation         : UIDeviceOrientation = .unknown
        
    
    var body: some View {
        ViewThatFits {
            ScrollView {
                VStack(spacing: 5) {
                    HStack(spacing: 5) {
                        Picker("Year", selection: self.$selectedYear) {
                            ForEach(self.model.availableYears, id: \.self) { year in
                                Text("\(year, format: .number.grouping(.never))")
                            }
                        }
                        .frame(minWidth: 80)
                        Spacer()
                        HStack {
                            if let image = UIImage(named: AppIconProvider.appIcon()) {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(RoundedRectangle(cornerRadius: 4))
                                    .frame(width: 20, height: 20)
                            }
                            Text("On Travel")
                                .font(.system(size: 20))
                        }
                        Spacer()
                        Button(action: {
                            self.showingExporter = true
                        }, label: {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 14))
                                .foregroundColor(.accentColor)
                        })
                        .frame(minWidth: 80)
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
                        .listSectionSeparator(.visible)
                    }
                    //.listStyle(.plain)
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
                updateCountryFromProperties()
            }
            /*
             .onChange(of: self.locationManager.location) {
             //updateCountry()
             }
             */
            .onChange(of: self.locationManager.storedProperties) {
                updateCountryFromProperties()
            }
            .onChange(of: self.model.allVisits) {
                refreshCalendarView.toggle()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { (_) in
                // Update remaining days
                self.model.remainingDays = Calendar.current.dateComponents([.day], from: Date.init(), to: Helper.getLastDayOfYear()).day!
                
                // Update model with saved data
                if self.model.allVisits.isEmpty {
                    let json : String = Helper.readJson(year: self.year)
                    if json.isEmpty {
                        let isoCode : String = Properties.instance.country!
                        if !isoCode.isEmpty {
                            let isoInfo : IsoCountryInfo = IsoCountryCodes.find(key: isoCode)!
                            let now     : Date           = Date.init()
                            let country : Country        = Country(isoInfo: isoInfo)
                            country.addVisit(date: now)
                            self.model.allVisits.insert(country)
                            self.flag = isoInfo.flag ?? ""
                            self.name = isoInfo.name
                            DispatchQueue.global().async {
                                Helper.saveJson(json: self.model.toJson())
                            }
                        }
                    } else {
                        let countries : [Country] = Helper.getCountriesFromJson(json: json)
                        for country in countries { self.model.allVisits.insert(country) }
                    }
                }
                
                updateCountryFromProperties()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { (_) in
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
            .onRotate { newOrientation in
                self.orientation = newOrientation
            }
        }
    }
    
    
    private func updateCountry() -> Void {
        // Avoid update country when on a plane
        if self.locationManager.location?.altitude ?? 0 > 4000 && self.locationManager.location?.speed ?? 0 > 250 { return }
        locationManager.geocode() { placemark, error in
            guard let placemark = placemark, error == nil else { return }
            DispatchQueue.main.async {
                if nil != placemark.isoCountryCode {                    
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
                            print("no country found -> add \(String(describing: isoInfo?.alpha2)) to list")
                        } else {
                            countryFound!.addVisit(date: now)
                            print("country \(countryFound!.isoInfo.alpha2) to list")
                        }
                        self.refreshCalendarView.toggle()
                        
                        self.model.remainingDays = Calendar.current.dateComponents([.day], from: now, to: Helper.getLastDayOfYear()).day!
                        
                        DispatchQueue.global().async {
                            Helper.saveJson(json: self.model.toJson())
                        }
                    }
                }
            }
        }
    }
    
    private func updateCountryFromProperties() -> Void {
        // Avoid update country when on a plane
        if self.locationManager.location?.altitude ?? 0 > 4000 && self.locationManager.location?.speed ?? 0 > 250 { return }
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
                        //print("no country found -> add \(String(describing: isoInfo?.alpha2)) to list")
                    } else {
                        countryFound!.addVisit(date: now)
                        //print("add country \(countryFound!.isoInfo.alpha2) to list")
                    }
                    self.refreshCalendarView.toggle()
                    
                    self.model.remainingDays = Calendar.current.dateComponents([.day], from: now, to: Helper.getLastDayOfYear()).day!

                    DispatchQueue.global().async {
                        Helper.saveJson(json: self.model.toJson())
                    }
                    self.model.availableYears = Helper.getAvailableYears()
                }
            }
        }
    }
    
    private func resetVisits() -> Void {
        self.model.allVisits.removeAll()
    }
}
