//
//  View+onRotate.swift
//  OnTravel
//
//  Created by Gerrit Grunwald on 28.08.24.
//

import Foundation
import SwiftUI


extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}
