//
//  OnTravelWidget_Extension.swift
//  OnTravelWidget-Extension
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
        var entries     : [OnTravelEntry] = []
        let currentDate : Date            = Date()
        for minuteOffset in 0 ..< 30 {
            let entryDate       : Date          = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
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



struct OnTravelWidget_ExtensionEntryView : View {
    var entry: Provider.Entry
    

    var body: some View {        
        VStack {
            if !self.entry.countries.isEmpty {
                let sorted = Array(self.entry.countries).sorted(by: { lhs, rhs in
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
                Spacer()
            } else {
                Text("No visits yet...")
                    .font(.system(size: 13))
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .containerBackground(for: .widget) {
            Color.widgetBackground
        }
        .cornerRadius(5)
        .edgesIgnoringSafeArea(.all)
    }
}

@main
struct OnTravelWidget_Extension: Widget {
    @Environment(\.widgetFamily) private var family
    
    let kind: String = "OnTravelWidget_Extension"

    var body: some WidgetConfiguration {
        
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            OnTravelWidget_ExtensionEntryView(entry: entry)
                .padding()
                .background()
        }
        .configurationDisplayName("OnTravel Widget")
        .description("Countries visited this month")
        .supportedFamilies([.systemLarge])
    }
}
