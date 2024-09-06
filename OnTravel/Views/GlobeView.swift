//
//  GlobeView.swift
//  OnTravel
//
//  Created by Gerrit Grunwald on 06.09.24.
//

import SwiftUI
import MapKit

struct GlobeView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject      private var model           : OnTravelModel
    @EnvironmentObject      private var locationManager : LocationManager
    @State                  private var multiPolygons   : [MKMultiPolygon]           = []
    @State                  private var polygons        : [MKPolygon]                = []
    @State                  private var coordinates     : [[CLLocationCoordinate2D]] = []
    @Namespace              private var onTravelMap
    

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
                    Text("Visited countries in \(Calendar.current.component(.year, from: Date.init()), format: .number.grouping(.never))")
                        .font(.system(size: 18))
                        .foregroundStyle(.primary)
                }
                Spacer()
            }
            .padding()
                                                         
                        
            ZStack(alignment: .center) {
                VStack {
                    MapReader { proxy in
                        Map(initialPosition: .region(MKCoordinateRegion(center: self.locationManager.getCurrentCoordinate(), span: MKCoordinateSpan(latitudeDelta: 90, longitudeDelta: 180))), interactionModes: [.rotate, .zoom, .pan]) {
                            ForEach(self.coordinates, id: \.self) { coords in
                                MapPolygon(coordinates: coords)
                                    .foregroundStyle(.red.opacity(0.7))                                                                        
                            }
                            Annotation("You", coordinate: self.locationManager.getCurrentCoordinate()) {
                                ZStack {                                    
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(Color.blue)
                                }
                            }
                        }
                        .mapStyle(.imagery(elevation: .realistic))
                    }
                }
                .mapScope(self.onTravelMap)
            }
            
            Spacer()
        }
        .padding()
        .task {
            let decoder = MKGeoJSONDecoder()
            for country in self.model.allVisits {
                let iso3 : String = country.isoInfo.alpha3
                if let jsonUrl = Bundle.main.url(forResource: iso3, withExtension: "geo.json") {
                    do {
                        let data        = try Data(contentsOf: jsonUrl)
                        let jsonObjects = try decoder.decode(data)
                        self.parse(jsonObjects, iso3: iso3)
                    } catch {
                        debugPrint("Error decoding GeoJSON: \(error)")
                    }
                } else {
                    debugPrint("json url not found")
                }
            }
            
            for multiPolygon in multiPolygons {
                for polygon in multiPolygon.polygons {
                    self.coordinates.append(polygon.coordinates)
                }
            }
            
            for polygon in self.polygons {
                self.coordinates.append(polygon.coordinates)
            }
        }
    }
    
    
    private func parse(_ jsonObjects: [MKGeoJSONObject], iso3: String) -> Void {
        for object in jsonObjects {
            if let feature = object as? MKGeoJSONFeature {
                for geometry in feature.geometry {
                    if let multiPolygon = geometry as? MKMultiPolygon {
                        //debugPrint("\(iso3) multipolygon found")
                        self.multiPolygons.append(multiPolygon)
                    } else if let polygon = geometry as? MKPolygon {
                        self.polygons.append(polygon)
                        //debugPrint("\(iso3) polygon found")
                    }
                }
            }
        }
    }
}
