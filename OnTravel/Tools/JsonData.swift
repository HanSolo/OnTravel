//
//  Root.swift
//  OnTravel
//
//  Created by Gerrit Grunwald on 24.08.24.
//

import Foundation

class JsonData: Codable {
    var iso   : String?
    var visits: [Double]?

    private enum CodingKeys: String, CodingKey {
        case iso    = "iso"
        case visits = "visits"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        iso    = try? container.decode(String.self, forKey: .iso)
        visits = try? container.decode([Double].self, forKey: .visits)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(iso, forKey: .iso)
        try? container.encode(visits, forKey: .visits)
    }
    
  
    public func getCountry() -> Country? {
        if nil == iso { return nil }
        
        let isoInfo : IsoCountryInfo? = IsoCountryCodes.find(key: self.iso ?? "")
        if nil == isoInfo { return nil }
        
        let country : Country = Country(isoInfo: isoInfo!)
        
        if self.visits != nil && !self.visits!.isEmpty {
            var dates : [Date] = []
            for epochSecond in self.visits! {
                let date : Date = Date(timeIntervalSince1970: epochSecond)
                dates.append(date)
            }
                     
            for date in dates { country.visits.insert(date) }
        }
        
        return country
    }
}
