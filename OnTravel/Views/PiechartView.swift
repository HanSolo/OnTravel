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
    @State                  private var data: [VisitData] = []
    
    @State var allVisits : Set<Country> {
        didSet {
            print("check")
            let totalVisits : Double = Double(self.allVisits.map( {$0.visits.count }).reduce(0, +))
            for country in self.allVisits {
                self.data.append(VisitData(country: country.isoInfo.name, visits: Double(country.visits.count) / totalVisits))
            }
        }
    }
        
    
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
                Text("Visits this year")
                Spacer()
            }
            .padding()
            
            Chart(data) { data in
                SectorMark(
                    angle       : .value(Text(verbatim: data.country), data.visits),
                    innerRadius : .ratio(0.6),
                    angularInset: 2.0
                )
                .foregroundStyle(by: .value(Text(verbatim: data.country), data.country))
                .cornerRadius(10.0)
                .annotation(position: .overlay, alignment: .center) {
                    Text("\(data.visits)")
                        .font(.headline)
                        .foregroundStyle(.white)
                }
            }
            
            Spacer()
        }
    }
}

struct VisitData: Identifiable {
    let id      : UUID = UUID()
    let country : String
    let visits  : Double
}
