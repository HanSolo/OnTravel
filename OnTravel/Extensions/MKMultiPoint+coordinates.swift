//
//  MKMultiPoint+coordinates.swift
//  OnTravel
//
//  Created by Gerrit Grunwald on 06.09.24.
//

import Foundation
import SwiftUI
import MapKit


public extension MKMultiPoint {
    
    var coordinates: [CLLocationCoordinate2D] {
        var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid, count: pointCount)
        getCoordinates(&coords, range: NSRange(location: 0, length: pointCount))
        return coords
    }
}
