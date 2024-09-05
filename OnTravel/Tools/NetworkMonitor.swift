//
//  NetworkMonitor.swift
//  CountryCounter
//
//  Created by Gerrit Grunwald on 20.08.24.
//

import Foundation
import Network
import SwiftUI


class NetworkMonitor: ObservableObject {
    @State public var online : Bool = false
    
    private let networkMonitor = NWPathMonitor()

    var isConnected : Bool  = false {
        didSet {
            Task {
                self.online = await RestController.isConnected()
            }
        }
    }

    
    init() {
        networkMonitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
            Task {
                await MainActor.run {
                    self.objectWillChange.send()
                }
            }
        }
        networkMonitor.start(queue: DispatchQueue.global())
    }
}

