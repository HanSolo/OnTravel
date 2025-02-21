//
//  OnTravelWidget.swift
//  OnTravelWidget
//
//  Created by Gerrit Grunwald on 02.09.24.
//

import WidgetKit
import SwiftUI


struct Provider: TimelineProvider {
    @EnvironmentObject private var model : OnTravelModel
    
    func placeholder(in context: Context) -> OnTravelEntry {
        let visitsThisMonth : [Country] = Helper.visitsThisMonthFromUserDefaults()
        return OnTravelEntry(date: Date(), countries: visitsThisMonth)
    }

    func getSnapshot(in context: Context, completion: @escaping (OnTravelEntry) -> ()) {
        let visitsThisMonth : [Country] = Helper.visitsThisMonthFromUserDefaults()
        let entry = OnTravelEntry(date: Date(), countries: visitsThisMonth)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<OnTravelEntry>) -> ()) {
        var entries : [OnTravelEntry] = []
        let now     : Date            = Date()
            
        for hourOffset in 0 ..< 2 { // 2 entries an hour
            let entryDate       : Date          = Calendar.current.date(byAdding: .hour, value: hourOffset, to: now)!            
            let visitsThisMonth : [Country]     = Helper.visitsThisMonthFromUserDefaults()
            let entry           : OnTravelEntry = OnTravelEntry(date: entryDate, countries: visitsThisMonth)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct OnTravelEntry: TimelineEntry {
    let date      : Date
    let countries : [Country]    
}



struct OnTravelWidgetEntryView : View {
    @Environment(\.widgetFamily) private var family
    
    var entry  : Provider.Entry
    

    var body: some View {
        let sorted : [Country] = Array(self.entry.countries).sorted(by: { lhs, rhs in
            return rhs.visits.count < lhs.visits.count
        })
        let count  : Int       = sorted.count
        
        if family == .systemLarge {
            VStack {
                if self.entry.countries.isEmpty {
                    Text("No visits yet...")
                        .font(.system(size: 13))
                } else {
                    ForEach(Array(sorted)) { country in
                        HStack {
                            Text(country.isoInfo.flag ?? "")
                                .font(.system(size: 24))
                            Text(country.isoInfo.name)
                                .font(.system(size: 13))
                            Spacer()
                            Text("\(country.getVisitsThisMonth())")
                                .font(.system(size: 13)).multilineTextAlignment(.trailing)
                        }
                    }
                    Spacer()
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .containerBackground(for: .widget) {
                Color.init(red: 0.1, green: 0.1, blue: 0.1)
            }
            .cornerRadius(5)
            .edgesIgnoringSafeArea(.all)
        } else {
            if self.entry.countries.isEmpty {
                VStack {
                    Text("No visits yet...")
                        .font(.system(size: 13))
                }
            } else {
                if count > 4 {
                    let left  : [Country] = Array(sorted.prefix(through: 3))
                    let right : [Country] = Array(sorted.suffix(from: 4))
                    HStack(alignment: .top, spacing: 20) {
                        VStack {
                            ForEach(Array(left)) { country in
                                HStack {
                                    Text(country.isoInfo.flag ?? "")
                                        .font(.system(size: 24))
                                    Text(country.isoInfo.alpha3)
                                        .font(.system(size: 13))
                                    Spacer()
                                    Text("\(country.getVisitsThisMonth())")
                                        .font(.system(size: 13)).multilineTextAlignment(.trailing)
                                }
                            }
                            Spacer()
                        }
                        VStack {
                            ForEach(Array(right)) { country in
                                HStack {
                                    Text(country.isoInfo.flag ?? "")
                                        .font(.system(size: 24))
                                    Text(country.isoInfo.alpha3)
                                        .font(.system(size: 13))
                                    Spacer()
                                    Text("\(country.getVisitsThisMonth())")
                                        .font(.system(size: 13)).multilineTextAlignment(.trailing)
                                }
                            }
                            Spacer()
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .containerBackground(for: .widget) {
                        Color.init(red: 0.1, green: 0.1, blue: 0.1)
                    }
                    .cornerRadius(5)
                    .edgesIgnoringSafeArea(.all)
                } else {
                    VStack {
                        if self.entry.countries.isEmpty {
                            Text("No visits yet...")
                                .font(.system(size: 13))
                        } else {
                            ForEach(Array(sorted)) { country in
                                HStack {
                                    Text(country.isoInfo.flag ?? "")
                                        .font(.system(size: 24))
                                    Text(country.isoInfo.name)
                                        .font(.system(size: 13))
                                    Spacer()
                                    Text("\(country.getVisitsThisMonth())")
                                        .font(.system(size: 13)).multilineTextAlignment(.trailing)
                                }
                            }
                            Spacer()
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .containerBackground(for: .widget) {
                        Color.init(red: 0.1, green: 0.1, blue: 0.1)
                    }
                    .cornerRadius(5)
                    .edgesIgnoringSafeArea(.all)
                }
            }
        }
    }
}


struct OnTravelWidget: Widget {
    @Environment(\.widgetFamily) private var family
    
    let kind: String = "OnTravelWidget"

    var body: some WidgetConfiguration {
        
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            OnTravelWidgetEntryView(entry: entry)
                    //.padding()
                    .background()
            }
        .configurationDisplayName("OnTravel Widget")
        .description("Countries visited this month")
        .supportedFamilies([.systemMedium, .systemLarge])
        }
}
