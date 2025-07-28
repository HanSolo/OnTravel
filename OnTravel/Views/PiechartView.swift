//
//  PiechartView.swift
//  OnTravel
//
//  Created by Gerrit Grunwald on 03.09.24.
//

import Foundation
import SwiftUI
import Charts


struct PiechartView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject      private var model      : OnTravelModel
    @State                  private var data       : [VisitData] = []
    @State                  private var countries  : Set<String> = []
    @State                  private var continents : Set<String> = []
            
    
    var body: some View {        
        VStack {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.primary)
                }
                .buttonStyle(.bordered)
                Spacer()
                VStack(alignment: .center) {
                    Text("Days on travel this year")
                        .font(.system(size: 18))
                        .foregroundStyle(.primary)                    
                }
                Spacer()
            }
            .padding()
                                             
            VStack(alignment: .center, spacing: 5) {
                Text("On travel recorded: \(self.model.totalDaysOnTravel()) \(self.model.totalDaysOnTravel() > 1 ? "days" : "day")")
                    .font(.system(size: 16))
                    .foregroundStyle(.primary)
                Text("In foreign countries: \(self.model.daysOnTravelOutsideHomeCountry()) \(self.model.totalDaysOnTravel() > 1 ? "days" : "day")")
                    .font(.system(size: 16))
                    .foregroundStyle(.primary)
            }
            .padding()
                        
            ZStack(alignment: .center) {
                Chart(self.data) { d in
                    SectorMark(
                        angle       : .value(Text(verbatim: d.country), d.visits),
                        innerRadius : .ratio(0.6),
                        angularInset: 2.0
                    )
                    .foregroundStyle(by: .value(Text(verbatim: d.country), d.country))
                    .foregroundStyle(d.color)
                    .cornerRadius(10.0)
                    .annotation(position: .overlay, alignment: .center) {
                        Text("\(d.visits)")
                            .font(.headline)
                            .foregroundStyle(.white)
                    }
                }
                VStack {
                    Text("\(Calendar.current.component(.year, from: Date.init()), format: .number.grouping(.never))")
                        .font(.system(size: 24))
                        .foregroundStyle(.primary)
                    Text("\(String(format: "%.0f", self.model.percentageOutsideHomeCountry()))% on travel")
                        .font(.system(size: 20))
                        .foregroundStyle(.secondary)
                    Text("\(self.countries.count) \(self.countries.count <= 1 ? "country" : "countries")")
                        .font(.system(size: 16))
                        .foregroundStyle(.secondary)
                    Text("\(self.continents.count) \(self.continents.count <= 1 ? "continent" : "continents")")
                        .font(.system(size: 16))
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
        }
        .padding()
        .task {
            var colorCounter : Int = 0
            if Properties.instance.ignoreHomeCountry! {
                let filteredVisits : Set<Country> = self.model.allVisits.filter{ $0.isoInfo.alpha2 != self.model.homeCountry.alpha2 }
                for country in filteredVisits.sorted(by: { $0.visits.count > $1.visits.count }) {
                    self.data.append(VisitData(country: country.isoInfo.name, visits: country.visits.count, color: Constants.COUNTRY_COLORS[colorCounter]))
                    if colorCounter < Constants.COUNTRY_COLORS.count - 1 {
                        colorCounter += 1
                    } else {
                        colorCounter = 0
                    }
                    self.countries.insert(country.isoInfo.name)
                    self.continents.insert(country.isoInfo.continent)
                }
            } else {
                for country in self.model.allVisits.sorted(by: { $0.visits.count > $1.visits.count }) {
                    self.data.append(VisitData(country: country.isoInfo.name, visits: country.visits.count, color: Constants.COUNTRY_COLORS[colorCounter]))
                    if colorCounter < Constants.COUNTRY_COLORS.count - 1 {
                        colorCounter += 1
                    } else {
                        colorCounter = 0
                    }
                    self.countries.insert(country.isoInfo.name)
                    self.continents.insert(country.isoInfo.continent)
                }
            }
        }
    }        
}

struct VisitData: Identifiable {
    let id      : UUID = UUID()
    let country : String
    let visits  : Int
    let color   : Color
}
