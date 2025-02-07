//
//  ContentView.swift
//  OnTravel
//
//  Created by Gerrit Grunwald on 24.08.24.
//

import SwiftUI
import Combine
import CoreLocation
import WidgetKit


struct ContentView: View {
    @Environment(\.dismiss)      var dismiss
    @Environment(\.displayScale) var displayScale
    @EnvironmentObject   private var model                        : OnTravelModel
    @EnvironmentObject   private var locationManager              : LocationManager
    @State               private var name                         : String              = ""
    @State               private var flag                         : String              = ""
    @State               private var refreshCalendarView          : Bool                = false
    @State               private var showingExporter              : Bool                = false
    @State               private var importVisible                : Bool                = false
    @State               private var selectedYear                 : Int                 = Calendar.current.component(.year, from: Date.init())
    @State               private var isoInfo                      : IsoCountryInfo?
    @State               private var year                         : Int                 = Calendar.current.component(.year, from: Date.init())
    @State               private var settingsVisible              : Bool                = false
    @State               private var chartVisible                 : Bool                = false
    @State               private var globeVisible                 : Bool                = false
    @State               private var sortedCountries              : [Country]           = []
    @State               private var sortedCountriesThisMonth     : [Country]           = []
    @State               private var sortedCountriesSelectedMonth : [Country]           = []
    @State               private var selectedTimeFrame            : Int                 = 0
    
    var calendarView : CalendarView = CalendarView(calendar: Calendar.current)
            
    
    var body: some View {
        
        ViewThatFits {
            VStack(spacing: 5) {
                HStack(spacing: 5) { // Title and icon
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
                            self.importVisible.toggle()
                        }, label: {
                            HStack {
                                Image(systemName: "square.and.arrow.down")
                                Text("Import from json")
                            }
                        })
                        
                        Button(action: {
                            self.globeVisible.toggle()
                        }, label: {
                            HStack {
                                Image(systemName: "globe.europe.africa")
                                Text("Show globe")
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
                .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                HStack(spacing: 5) { // Current country and flag
                    Spacer()
                    Text(self.flag)
                        .font(.system(size: 36))
                    Text(self.name)
                        .font(.system(size: 20))
                    Spacer()
                }
                HStack() { // Target sunrise and sunset
                    let latTarget : Double = self.locationManager.latitude
                    let lonTarget : Double = self.locationManager.longitude
                    if latTarget != 0 && lonTarget != 0 {
                        Label("\(self.model.metric ? self.locationManager.sunriseMetric : self.locationManager.sunriseImperial)", systemImage: "sunrise")
                            .font(.system(size: 12))
                        Spacer()
                        Text("\(self.locationManager.abbreviation) (\(self.locationManager.offsetFromGMT > 0 ? "+" : "")\(String(format: "%.1f", (self.locationManager.offsetFromGMT / 3600)))h)")
                            .font(.system(size: 12))
                        Spacer()
                        Label("\(self.model.metric ? self.locationManager.sunsetMetric : self.locationManager.sunsetImperial)", systemImage: "sunset")
                            .font(.system(size: 12))
                    }
                }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                                
                if self.isoInfo != nil {
                    let text : String = Helper.getCurrencyRateString(homeCountry: self.model.homeCountry, currentCountry: self.isoInfo!)
                    if !text.isEmpty {
                        Text("\(text)")
                            .font(.system(size: 12))
                    }
                }
                Text("You've been to \(self.model.allVisits.count) \(self.model.allVisits.count < 2 ? "country" : "countries") in \(self.year, format: .number.grouping(.never))")
                    .font(.system(size: 16))
                Text("(\(self.model.remainingDays) remaining days)")
                    .font(.system(size: 14))
                
                
                Picker("", selection: $selectedTimeFrame) {
                    Text("This Year").tag(0)
                    Text("This Month").tag(1)
                }
                .pickerStyle(.segmented)
                
                
                List {
                    Section {
                        ForEach(Array(self.selectedTimeFrame == 0 ? self.sortedCountries : self.sortedCountriesThisMonth)) { country in
                            HStack {
                                Text(country.isoInfo.flag ?? "")
                                    .font(.system(size: 24))
                                Text(country.isoInfo.name)
                                    .font(.system(size: 13))
                                Spacer()
                                Text("\(self.selectedTimeFrame == 0 ? country.getAllVisits() : country.getVisitsThisMonth())")
                                    .font(.system(size: 13)).multilineTextAlignment(.trailing)
                            }
                        }
                    }
                    .listSectionSeparator(.visible)
                }
                .contentMargins(.top, 5, for: .scrollContent)
                .contentMargins(.trailing, 5, for: .scrollContent)
                .contentMargins(.bottom, 5, for: .scrollContent)
                .contentMargins(.leading, 5, for: .scrollContent)
                .frame(minHeight: 280, maxHeight: 280)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                
                ScrollView {
                    self.calendarView
                        .id(self.refreshCalendarView)
                    Text("Visits selected month")
                        .font(.system(size: 14))
                    List {
                        Section {
                            ForEach(Array(self.sortedCountriesSelectedMonth)) { country in
                                HStack {
                                    Text(country.isoInfo.flag ?? "")
                                        .font(.system(size: 24))
                                    Text(country.isoInfo.name)
                                        .font(.system(size: 13))
                                    Spacer()
                                    Text("\(country.getVisitsSelectedMonth(month: self.model.selectedMonth))")
                                        .font(.system(size: 13)).multilineTextAlignment(.trailing)
                                }
                            }
                        }
                        .listSectionSeparator(.visible)
                    }
                    .contentMargins(.top, 5, for: .scrollContent)
                    .contentMargins(.trailing, 5, for: .scrollContent)
                    .contentMargins(.bottom, 5, for: .scrollContent)
                    .contentMargins(.leading, 5, for: .scrollContent)
                    .frame(minHeight: 280, maxHeight: 280)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    
                    Button(action: {
                        self.globeVisible.toggle()
                    }, label: {
                        HStack {
                            Image(systemName: "globe.europe.africa")
                            Text("Show globe")
                        }
                    })
                    /*
                    MapView()
                        .frame(width: 360, height: 237)
                     */
                }
            }
            .onAppear {
                self.refreshCalendarView.toggle()
            }
            .task {
                self.updateSortedCountries()
                self.updateSortedCountriesForSelection()
                WidgetCenter.shared.reloadAllTimelines()
            }
            .onChange(of: self.locationManager.storedProperties) {
                self.updateCountryFromProperties()
            }            
            .onChange(of: self.model.allVisits) {
                refreshCalendarView.toggle()
                self.updateSortedCountries()
                self.updateSortedCountriesForSelection()
            }
            .onChange(of: self.model.selectedMonth) {
                self.updateSortedCountriesForSelection()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { (_) in
                // Start location updates
                self.locationManager.startLocationUpdates()
                
                // Update remaining days
                self.model.remainingDays = Calendar.current.dateComponents([.day], from: Date.init(), to: Helper.lastDayOfYear()).day!
                
                // Update model with saved data
                if self.model.allVisits.isEmpty {
                    if Helper.jsonExists(year: self.year) {
                        let json : String = Helper.readJson(year: self.year)
                        if json.isEmpty {
                            debugPrint("json is empty")
                            let isoCode : String = Properties.instance.country!
                            if !isoCode.isEmpty {
                                let isoInfo : IsoCountryInfo = IsoCountryCodes.find(key: isoCode)!
                                let now     : Date           = Date.init()
                                let country : Country        = Country(isoInfo: isoInfo)
                                _ = country.addVisit(date: now)
                                self.model.allVisits.insert(country)
                                self.flag = isoInfo.flag ?? ""
                                self.name = isoInfo.name                                
                            }
                        } else {
                            debugPrint("json is not empty")
                            let countries : [Country] = Helper.countriesFromJson(jsonTxt: json)
                            for country in countries { self.model.allVisits.insert(country) }
                        }
                    } else {
                        //Swift.debugPrint("json file does not exists when try to read in ContentView")
                    }
                } else {                                        
                    let countriesThisMonth : [Country] = Helper.visitsThisMonthFromUserDefaults()
                    if countriesThisMonth.isEmpty { return }
                    debugPrint("Refresh with visits from this month")
                    for country in countriesThisMonth {
                        if self.model.allVisits.contains(where: { $0.isoInfo.alpha2.lowercased() == country.isoInfo.alpha2.lowercased() }) {
                            for visit in country.visits {
                                if let countryFound = self.model.allVisits.filter({ $0.isoInfo.alpha2.lowercased() == country.isoInfo.alpha2.lowercased() }).first {
                                    countryFound.addVisit(date: visit)
                                } else {
                                    self.model.allVisits.insert(country)
                                }
                            }
                        }
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
            .sheet(isPresented: self.$importVisible, content: {
                ImportJsonView().onDisappear() {
                    debugPrint("Returned from import view")
                }
            })
            .sheet(isPresented: self.$settingsVisible, content: {
                SettingsView().onDisappear() {
                    self.updateSortedCountries()
                    Helper.updateCurrencies(forceUpdate: true)
                }
            })
            .sheet(isPresented: self.$chartVisible, content: {
                PiechartView()
            })
            .sheet(isPresented: self.$globeVisible, content: {
                GlobeView()
            })
        }
    }
    
    private func updateSortedCountries() -> Void {
        if self.model.ignoreHomeCountry {
            self.sortedCountries = self.model.allVisits.filter({ $0.isoInfo.alpha2 != self.model.homeCountry.alpha2 }).sorted(by: { lhs, rhs in
                return rhs.visits.count < lhs.visits.count
            })
            self.sortedCountriesThisMonth = Helper.visitsThisMonth(allVisits: self.model.allVisits).filter({ $0.isoInfo.alpha2 != self.model.homeCountry.alpha2 }).sorted(by: { lhs, rhs in
                return rhs.visits.count < lhs.visits.count
            })
            
            /*
            self.sortedCountries = Helper.visitsThisYearFromUserDefaults().filter({ $0.isoInfo.alpha2 != self.model.homeCountry.alpha2 }).sorted(by: { lhs, rhs in
                return rhs.visits.count < lhs.visits.count
            })
            self.sortedCountriesThisMonth = Helper.visitsThisMonth(allVisits: Set<Country>(self.sortedCountries)).filter({ $0.isoInfo.alpha2 != self.model.homeCountry.alpha2 }).sorted(by: { lhs, rhs in
                return rhs.visits.count < lhs.visits.count
            })
            */
            Helper.visitsThisMonthToUserDefaults(jsonTxt: Helper.visitsToJson(allVisits: Set<Country>(self.sortedCountriesThisMonth)))
        } else {
            self.sortedCountries = self.model.allVisits.sorted(by: { lhs, rhs in
                return rhs.visits.count < lhs.visits.count
            })
            self.sortedCountriesThisMonth = Helper.visitsThisMonth(allVisits: self.model.allVisits).sorted(by: { lhs, rhs in
                return rhs.visits.count < lhs.visits.count
            })
            
            /*
            self.sortedCountries = Helper.visitsThisYearFromUserDefaults().sorted(by: { lhs, rhs in
                return rhs.visits.count < lhs.visits.count
            })
            self.sortedCountriesThisMonth = Helper.visitsThisMonth(allVisits: Set<Country>(self.sortedCountries)).sorted(by: { lhs, rhs in
                return rhs.visits.count < lhs.visits.count
            })
            */
            Helper.visitsThisMonthToUserDefaults(jsonTxt: Helper.visitsToJson(allVisits: Set<Country>(self.sortedCountriesThisMonth)))
        }
        
    }
    
    private func updateSortedCountriesForSelection() -> Void {
        if self.model.ignoreHomeCountry {
            self.sortedCountriesSelectedMonth = Helper.visitsSelectedMonth(selectedMonth: self.model.selectedMonth, allVisits: Set<Country>(self.sortedCountries)).filter({ $0.isoInfo.alpha2 != self.model.homeCountry.alpha2 }).sorted(by: { lhs, rhs in
                return rhs.visits.count < lhs.visits.count
            })
        } else {
            self.sortedCountriesSelectedMonth = Helper.visitsSelectedMonth(selectedMonth: self.model.selectedMonth, allVisits: Set<Country>(self.sortedCountries)).sorted(by: { lhs, rhs in
                return rhs.visits.count < lhs.visits.count
            })
        }
    }
    

    
    private func updateCountryFromProperties() -> Void {
        // Avoid update country when altitude > 6000m or speed > 300 kph (usually when on a plane)
        if self.locationManager.location?.altitude ?? 0 > Constants.ALTITUDE_LIMIT || self.locationManager.location?.speed ?? 0 > Constants.SPEED_LIMIT { return }
        DispatchQueue.main.async {
            self.model.holidays = Properties.instance.holidays!
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
                        _ = country.addVisit(date: now)
                        self.model.allVisits.insert(country)
                    } else {
                        _ = countryFound!.addVisit(date: now)
                    }
                    self.refreshCalendarView.toggle()
                    
                    self.model.remainingDays  = Calendar.current.dateComponents([.day], from: now, to: Helper.lastDayOfYear()).day!
                    self.model.availableYears = Helper.availableYears()
                }
            }
        }
    }
}
