//
//  CalendarView.swift
//  CountryCounter
//
//  Created by Gerrit Grunwald on 23.08.24.
//

import Foundation
import SwiftUI
import UIKit


struct CalendarView: View {
    @EnvironmentObject private var model : OnTravelModel
    private let calendar        : Calendar
    private let monthFormatter  : DateFormatter
    private let dayFormatter    : DateFormatter
    private let weekDayFormatter: DateFormatter
    private let fullFormatter   : DateFormatter
    private let dateFormatter   : DateFormatter

    @State private var showingAlert : Bool   = false
    @State private var selectedDate : Date   = Self.now
    private static var now          : Date   = Date()

        
    
    init(calendar: Calendar) {
        self.calendar         = calendar
        self.monthFormatter   = DateFormatter(dateFormat: "MMMM YYYY", calendar: calendar)
        self.dayFormatter     = DateFormatter(dateFormat: "d", calendar: calendar)
        self.weekDayFormatter = DateFormatter(dateFormat: "EEEEE", calendar: calendar)
        self.fullFormatter    = DateFormatter(dateFormat: "dd MMMM yyyy", calendar: calendar)
        self.dateFormatter    = DateFormatter(dateFormat: "dd/MM/yyyy", calendar: calendar)
    }
    
    
    var body: some View {
        VStack {
            CalendarViewComponent(calendar: calendar, date: $selectedDate, content: { date in
                    ZStack {
                        Button(action: {
                            self.selectedDate = date
                            self.showingAlert = true
                        }) {
                            Text(dayFormatter.string(from: date))
                                .font(.system(size: 14))
                                .padding(EdgeInsets(top: 1, leading: 0, bottom: 6, trailing: 0))
                                .frame(width: 24, height: 24)
                                .foregroundStyle(calendar.isDateInToday(date) ? Color.accentColor : .primary )
                                .cornerRadius(5)
                        }
                        .alert(
                            Text("At \(dateFormatter.string(from: self.selectedDate)) you've been to"),
                            isPresented: $showingAlert
                        ) {
                            Button("OK", role: .cancel) {}
                        } message: {
                            VStack(spacing: 5) {
                                let arrayMap : Array  = getCountriesInDate(date: self.selectedDate).map() { "\($0.isoInfo.flag ?? "") \($0.isoInfo.name)" }
                                Text(arrayMap.joined(separator: "\n"))
                                    .font(.system(size: 14))
                            }
                            .frame(minHeight: 300)
                            .padding()
                        }
                        if (dateHasEvents(date: date)) {
                            HStack(alignment: .center, spacing: 2) {
                                ForEach(getFlagsInDate(date: date), id: \.self) { flag in
                                    if self.model.ignoreHomeCountry && flag == self.model.homeCountry.flag {
                                        
                                    } else {
                                        Text("\(flag)")
                                            .font(.system(size: 12))
                                    }
                                }
                            }
                            .offset(x: CGFloat(0), y: CGFloat(12))
                        }
                    }
                },
                trailing: { date in
                    Text(dayFormatter.string(from: date))
                        .foregroundColor(.secondary)
                        .font(.system(size: 14))
                },
                header: { date in
                    Text(weekDayFormatter.string(from: date))
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                },
                title: { date in
                    HStack {
                        
                        Button {
                            guard let newDate = calendar.date(byAdding: .month, value: -1, to: selectedDate) else { return}
                            selectedDate = newDate
                            
                        } label: {
                            Label(
                                title: { Text("Previous") },
                                icon: {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 18))
                                    
                                }
                            )
                            .labelStyle(IconOnlyLabelStyle())
                            .padding(.horizontal)
                        }
                        
                        Spacer()
                        
                        Button {
                            selectedDate = Date.now
                        } label: {
                            Text(monthFormatter.string(from: date))
                                .foregroundColor(.blue)
                                .font(.system(size: 18))
                                .padding(2)
                        }
                        
                        Spacer()
                        
                        Button {
                            guard let newDate = calendar.date(byAdding: .month, value: 1, to: selectedDate) else { return }
                            selectedDate = newDate
                            
                        } label: {
                            Label(
                                title: { Text("Next") },
                                icon: {
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 18))
                                    
                                }
                            )
                            .labelStyle(IconOnlyLabelStyle())
                            .padding(.horizontal)
                        }
                    }
                }
            )
            .equatable()
        }
    }
    
    
    func dateHasEvents(date: Date) -> Bool {
        for country in self.model.allVisits {
            for visit in country.visits {
                if calendar.isDate(date, inSameDayAs: visit) {
                    return true
                }
            }
        }
        return false
    }
    
    func numberOfEventsInDate(date: Date) -> Int {
        var count: Int = 0
        for country in self.model.allVisits {
            for visit in country.visits {
                if calendar.isDate(date, inSameDayAs: visit) {
                    count += 1
                }
            }
        }
        return count
    }
    
    func getFlagsInDate(date: Date) -> [String] {
        var flags : [String] = []
        for country in self.model.allVisits {
            for visit in country.visits {
                if calendar.isDate(date, inSameDayAs: visit) {
                    flags.append(country.isoInfo.flag ?? "")
                }
            }
        }
        return flags
    }
    
    func getCountriesInDate(date: Date) -> [Country] {
        var countries : [Country] = []
        for country in self.model.allVisits {
            for visit in country.visits {
                if calendar.isDate(date, inSameDayAs: visit) {
                    countries.append(country)
                }
            }
        }
        return countries
    }
}

// MARK: - Component

public struct CalendarViewComponent<Day: View, Header: View, Title: View, Trailing: View>: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject private  var model : OnTravelModel

    // Injected dependencies
    private var calendar: Calendar
    @Binding private var date: Date
    private let content : (Date) -> Day
    private let trailing: (Date) -> Trailing
    private let header  : (Date) -> Header
    private let title   : (Date) -> Title
    
    // Constants
    private let daysInWeek = 7
    
    
    public init(
        calendar             : Calendar,
        date                 : Binding<Date>,
        @ViewBuilder content : @escaping (Date) -> Day,
        @ViewBuilder trailing: @escaping (Date) -> Trailing,
        @ViewBuilder header  : @escaping (Date) -> Header,
        @ViewBuilder title   : @escaping (Date) -> Title
    ) {
        self.calendar = calendar
        self._date    = date
        self.content  = content
        self.trailing = trailing
        self.header   = header
        self.title    = title
    }
    
    public var body: some View {
        let month = date.startOfMonth(using: calendar)
        let days = makeDays()
        
        VStack {
            
            Section(header: title(month)) { }
            
            VStack {
                
                LazyVGrid(columns: Array(repeating: GridItem(), count: daysInWeek)) {
                    ForEach(days.prefix(daysInWeek), id: \.self, content: header)
                }
                
                Divider()
                
                LazyVGrid(columns: Array(repeating: GridItem(), count: daysInWeek)) {
                    ForEach(days, id: \.self) { date in
                        if calendar.isDate(date, equalTo: month, toGranularity: .month) {
                            content(date)
                        } else {
                            trailing(date)
                        }
                    }
                }
            }
            .frame(height: days.count == 42 ? 300 : 270)
            //.shadow(color: colorScheme == .dark ? .white.opacity(0.4) : .black.opacity(0.35), radius: 5)
        }
    }
}

// MARK: - Conformances

extension CalendarViewComponent: Equatable {
    public static func == (lhs: CalendarViewComponent<Day, Header, Title, Trailing>, rhs: CalendarViewComponent<Day, Header, Title, Trailing>) -> Bool {
        lhs.calendar == rhs.calendar && lhs.date == rhs.date
    }
}

// MARK: - Helpers

private extension CalendarViewComponent {
    func makeDays() -> [Date] {
        guard let monthInterval  = calendar.dateInterval(of: .month, for: date),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
              let monthLastWeek  = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end - 1)
        else {
            return []
        }

        let dateInterval = DateInterval(start: monthFirstWeek.start, end: monthLastWeek.end)
        return calendar.generateDays(for: dateInterval)
    }
}

private extension Calendar {
    func generateDates(for dateInterval: DateInterval, matching components: DateComponents) -> [Date] {
        var dates = [dateInterval.start]

        enumerateDates(startingAfter : dateInterval.start, matching : components, matchingPolicy: .nextTime) { date, _, stop in
            guard let date = date else { return }

            guard date < dateInterval.end else {
                stop = true
                return
            }

            dates.append(date)
        }

        return dates
    }

    func generateDays(for dateInterval: DateInterval) -> [Date] {
        generateDates(for : dateInterval, matching: dateComponents([.hour, .minute, .second], from: dateInterval.start))
    }
}

private extension Date {
    func startOfMonth(using calendar: Calendar) -> Date {
        calendar.date(from: calendar.dateComponents([.year, .month], from: self)) ?? self
    }
}
