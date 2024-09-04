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
            Color.init(red: 0.1, green: 0.1, blue: 0.1)
        }
        .cornerRadius(5)
        .edgesIgnoringSafeArea(.all)
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
