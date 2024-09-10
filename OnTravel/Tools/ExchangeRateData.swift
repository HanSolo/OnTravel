//
//  ExchangeRateData.swift
//  OnTravel
//
//  Created by Gerrit Grunwald on 10.09.24.
//

import Foundation


class ExchangeRateData : Codable {
    var provider           : String?
    var documentation      : String?
    var result             : String?
    var timeLastUpdateUtc  : String?
    var baseCode           : String?
    var timeNextUpdateUnix : Int?
    var timeEolUnix        : Int?
    var rates              : Rates?
    var termsOfUse         : String?
    var timeNextUpdateUtc  : String?
    var timeLastUpdateUnix : Int?
    
    
    private enum CodingKeys: String, CodingKey {
        case provider           = "provider"
        case documentation      = "documentation"
        case result             = "result"
        case timeLastUpdateUtc  = "time_last_update_utc"
        case baseCode           = "base_code"
        case timeNextUpdateUnix = "time_next_update_unix"
        case timeEolUnix        = "time_eol_unix"
        case rates              = "rates"
        case termsOfUse         = "terms_of_use"
        case timeNextUpdateUtc  = "time_next_update_utc"
        case timeLastUpdateUnix = "time_last_update_unix"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        provider           = try? container.decode(String.self, forKey: .provider)
        documentation      = try? container.decode(String.self, forKey: .documentation)
        result             = try? container.decode(String.self, forKey: .result)
        timeLastUpdateUtc  = try? container.decode(String.self, forKey: .timeLastUpdateUtc)
        baseCode           = try? container.decode(String.self, forKey: .baseCode)
        timeNextUpdateUnix = try? container.decode(Int.self, forKey: .timeNextUpdateUnix)
        timeEolUnix        = try? container.decode(Int.self, forKey: .timeEolUnix)
        rates              = try? container.decode(Rates.self, forKey: .rates)
        termsOfUse         = try? container.decode(String.self, forKey: .termsOfUse)
        timeNextUpdateUtc  = try? container.decode(String.self, forKey: .timeNextUpdateUtc)
        timeLastUpdateUnix = try? container.decode(Int.self, forKey: .timeLastUpdateUnix)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(provider, forKey: .provider)
        try? container.encode(documentation, forKey: .documentation)
        try? container.encode(result, forKey: .result)
        try? container.encode(timeLastUpdateUtc, forKey: .timeLastUpdateUtc)
        try? container.encode(baseCode, forKey: .baseCode)
        try? container.encode(timeNextUpdateUnix, forKey: .timeNextUpdateUnix)
        try? container.encode(timeEolUnix, forKey: .timeEolUnix)
        try? container.encode(rates, forKey: .rates)
        try? container.encode(termsOfUse, forKey: .termsOfUse)
        try? container.encode(timeNextUpdateUtc, forKey: .timeNextUpdateUtc)
        try? container.encode(timeLastUpdateUnix, forKey: .timeLastUpdateUnix)
    }
}
