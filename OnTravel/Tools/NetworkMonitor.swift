//
//  NetworkMonitor.swift
//  CountryCounter
//
//  Created by Gerrit Grunwald on 20.08.24.
//

import Foundation
import Network

class NetworkMonitor: ObservableObject {
    private let networkMonitor = NWPathMonitor()

    var isConnected : Bool  = false {
        didSet {
            Task {
                self.online = await RestController.isConnected()
            }
        }
    }
    var online : Bool = false

    
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


