//
//  MapView.swift
//  OnTravel
//
//  Created by Gerrit Grunwald on 27.08.24.
//

import SwiftUI
import SVGView


struct MapView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject private var model            : OnTravelModel
    @EnvironmentObject private var locationManager  : LocationManager
    @State             private var allCountries     : [SVGNode] = []
    @State             private var visitedCountries : [SVGNode] = []
    @State             private var mapView          : SVGView   = SVGView(contentsOf: (Bundle.main.url(forResource: "world1", withExtension: "svg"))!)
    @State             private var visitedFill      : Color?
    @State             private var notVisitedFill   : Color?
    
    
    
    var body: some View {
        ZStack {
            //self.mapView
            
            ForEach(allCountries, id: \.self) { svgNode in
                svgNode.toSwiftUI()
                    .colorMultiply(self.visitedCountries.contains(svgNode) ? self.visitedFill! : self.notVisitedFill!)
                    .opacity(self.visitedCountries.contains(svgNode) ? 1.0 : 0.8)
                    .saturation(1.0)
                    .scaleEffect(0.3567888999, anchor: UnitPoint(x: 0, y: 0))
            }
            
        }
        .task {
            self.visitedFill    = self.colorScheme == .dark ? Color(red: 255, green: 0, blue: 0) : Color(red: 200, green: 00, blue: 0)
            self.notVisitedFill = self.colorScheme == .dark ? Color(red: 10, green: 10, blue: 10)  : Color(red: 100, green: 100, blue: 100)
            if !self.model.allVisits.isEmpty {
                for isoCountry in IsoCountries.allCountries {
                    for country in self.model.allVisits {
                        if country.isoInfo.alpha2 == isoCountry.alpha2 {
                            if let node = self.mapView.getNode(byId: country.isoInfo.alpha2.uppercased()) {
                                self.visitedCountries.append(node)
                            }
                        }
                        if let node = self.mapView.getNode(byId: isoCountry.alpha2.uppercased()) {
                            self.allCountries.append(node)
                        }
                    }
                    
                }
            }
        }
    }
}

extension SVGNode: Hashable {
    
    public static func == (lhs: SVGNode, rhs: SVGNode) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
