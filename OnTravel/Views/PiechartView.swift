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
    @EnvironmentObject      private var model : OnTravelModel
    @State                  private var data  : [VisitData] = []
            
    
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
                    Text("On travel this year")
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
                        
            Chart(self.data) { d in
                SectorMark(
                    angle       : .value(Text(verbatim: d.country), d.visits),
                    innerRadius : .ratio(0.6),
                    angularInset: 2.0
                )
                .foregroundStyle(by: .value(Text(verbatim: d.country), d.country))
                .cornerRadius(10.0)
                .annotation(position: .overlay, alignment: .center) {
                    Text("\(d.visits)")
                        .font(.headline)
                        .foregroundStyle(.white)
                }
            }
            
            Spacer()
        }
        .padding()
        .task {
            //let totalVisits : Double      = Double(self.model.allVisits.map( {$0.visits.count }).reduce(0, +))
            debugPrint("Home country: \(self.model.homeCountry)")
            for country in self.model.allVisits {
                self.data.append(VisitData(country: country.isoInfo.name, visits: country.visits.count))
            }
        }
    }
}

struct VisitData: Identifiable {
    let id      : UUID = UUID()
    let country : String
    let visits  : Int
}
