//
//  Storage.swift
//  GlucoTracker
//
//  Created by Gerrit Grunwald on 01.08.20.
//  Copyright © 2020 Gerrit Grunwald. All rights reserved.
//

import Foundation
import SwiftUI
import os.log


extension Key {
    static let lastLat            : Key = "lastLat"
    static let lastLon            : Key = "lastLon"
    static let timestamp          : Key = "timestamp"
    static let country            : Key = "country"
    static let flag               : Key = "flag"
    static let jsonBookmark       : Key = "jsonBookmark"
    static let homeCountryIndex   : Key = "homeCountryIndex"
    static let ignoreHomeCountry  : Key = "ignoreHomeCountry"
    static let lastCurrencyUpdate : Key = "lastCurrencyUpdate" 
}



// Define storage
public struct Properties {
    
    static var instance = Properties()
    
    @UserDefault(key: .lastLat, defaultValue: 0.0)
    var lastLat: Double? // last location latitude
    
    @UserDefault(key: .lastLon, defaultValue: 0.0)
    var lastLon: Double? // last location longitude
    
    @UserDefault(key: .timestamp, defaultValue: Date().timeIntervalSince1970)
    var timestamp: Double? // last location timestamp
    
    @UserDefault(key: .country, defaultValue: "")
    var country: String? // country
    
    @UserDefault(key: .flag, defaultValue: "")
    var flag: String? // flag
    
    @UserDefault(key: .jsonBookmark, defaultValue: "")
    var jsonBookmark: String?
        
    @UserDefault(key: .homeCountryIndex, defaultValue: 0)
    var homeCountryIndex: Int?
    
    @UserDefault(key: .ignoreHomeCountry, defaultValue: false)
    var ignoreHomeCountry: Bool?
    
    @UserDefault(key: .lastCurrencyUpdate, defaultValue: Date.init().timeIntervalSince1970 - Constants.SECONDS_48H)
    var lastCurrencyUpdate: Double?
        
    private init() {}
}
