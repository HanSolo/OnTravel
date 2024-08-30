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
    
    
    var body: some View {
        ZStack {
            //self.mapView
            
            let visitedFill    = self.colorScheme == .dark ? Constants.VISITED_FILL_DARK     : Constants.VISITED_FILL_BRIGHT
            let notVisitedFill = self.colorScheme == .dark ? Constants.NOT_VISITED_FILL_DARK : Constants.NOT_VISITED_FILL_BRIGHT
            
            ForEach(allCountries, id: \.self) { svgNode in
                svgNode.toSwiftUI()
                    .colorMultiply(self.visitedCountries.contains(svgNode) ? visitedFill : notVisitedFill)
                    .opacity(self.visitedCountries.contains(svgNode) ? 1.0 : 0.8)
                    .saturation(1.0)
                    .scaleEffect(0.3567888999, anchor: UnitPoint(x: 0, y: 0))
            }
            
        }
        .task {            
            updateNodes()
        }
        .onChange(of: self.model.allVisits) {
            updateNodes()
        }
    }
    
    private func updateNodes() -> Void {
        if !self.model.allVisits.isEmpty {
            self.allCountries.removeAll()
            self.visitedCountries.removeAll()
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

extension SVGNode: Hashable {
    
    public static func == (lhs: SVGNode, rhs: SVGNode) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
