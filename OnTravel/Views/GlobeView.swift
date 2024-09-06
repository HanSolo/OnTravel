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
                    Text("Globe")
                        .font(.system(size: 18))
                        .foregroundStyle(.primary)
                }
                Spacer()
            }
            .padding()
                                                         
                        
            ZStack(alignment: .center) {
                VStack {
                    MapReader { proxy in
                        Map(interactionModes: [.rotate, .zoom, .pan], scope: self.onTravelMap)
                            .mapStyle(.imagery(elevation: .realistic))
                            .onTapGesture { position in
                                if let coordinate = proxy.convert(position, from: .local) {
                                    print(coordinate)
                                }
                            }                            
                    }
                }
                .mapScope(self.onTravelMap)
            }
            
            Spacer()
        }
        .padding()
        /*
        .task {
            self.position = MapCameraPosition.region(MKCoordinateRegion(center: self.locationManager.location?.coordinate!,
                                                                        span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)))
        }
        */
    }
}
