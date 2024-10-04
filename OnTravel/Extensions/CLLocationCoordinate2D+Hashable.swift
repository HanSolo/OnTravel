//
//  CLLocationCoordinate2D+Hashable.swift
//  OnTravel
//
//  Created by Gerrit Grunwald on 06.09.24.
//

import Foundation
import MapKit


extension CLLocationCoordinate2D: @retroactive Equatable {}
extension CLLocationCoordinate2D : @retroactive Hashable {
    
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
    
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
}

