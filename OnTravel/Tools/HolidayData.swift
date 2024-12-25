//
//  HolidayData.swift
//  OnTravel
//
//  Created by Gerrit Grunwald on 19.12.24.
//

import Foundation


class HolidayData: Codable {
    var query     : String?
    var holidays  : [Holidays]?
    var status    : Int?
    var requestId : String?

    
    private enum CodingKeys: String, CodingKey {
        case query     = "query"
        case holidays  = "holidays"
        case status    = "status"
        case requestId = "requestId"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        query     = try? container.decode(String.self,     forKey: .query)
        holidays  = try? container.decode([Holidays].self, forKey: .holidays)
        status    = try? container.decode(Int.self,        forKey: .status)
        requestId = try? container.decode(String.self,     forKey: .requestId)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(query,     forKey: .query)
        try? container.encode(holidays,  forKey: .holidays)
        try? container.encode(status,    forKey: .status)
        try? container.encode(requestId, forKey: .requestId)
    }
}

class Holidays: Codable {
    var country      : String?
    var weekday      : Weekday?
    var subdivisions : [Int]?
    var date         : String?
    var id           : String?
    var substitute   : Bool?
    var type         : String?
    var observed     : String?
    var nameLocal    : String?
    var end          : String?
    var start        : String?
    var name         : String?
    var isPublic     : Bool?

    
    private enum CodingKeys: String, CodingKey {
        case country      = "country"
        case weekday      = "weekday"
        case subdivisions = "subdivisions"
        case date         = "date"
        case id           = "id"
        case substitute   = "substitute"
        case type         = "type"
        case observed     = "observed"
        case nameLocal    = "name_local"
        case end          = "end"
        case start        = "start"
        case name         = "name"
        case isPublic     = "public"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        country       = try? container.decode(String.self,  forKey: .country)
        weekday       = try? container.decode(Weekday.self, forKey: .weekday)
        subdivisions  = try? container.decode([Int].self,   forKey: .subdivisions)
        date          = try? container.decode(String.self,  forKey: .date)
        id            = try? container.decode(String.self,  forKey: .id)
        substitute    = try? container.decode(Bool.self,    forKey: .substitute)
        type          = try? container.decode(String.self,  forKey: .type)
        observed      = try? container.decode(String.self,  forKey: .observed)
        nameLocal     = try? container.decode(String.self,  forKey: .nameLocal)
        end           = try? container.decode(String.self,  forKey: .end)
        start         = try? container.decode(String.self,  forKey: .start)
        name          = try? container.decode(String.self,  forKey: .name)
        isPublic      = try? container.decode(Bool.self,    forKey: .isPublic)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(country,      forKey: .country)
        try? container.encode(weekday,      forKey: .weekday)
        try? container.encode(subdivisions, forKey: .subdivisions)
        try? container.encode(date,         forKey: .date)
        try? container.encode(id,           forKey: .id)
        try? container.encode(substitute,   forKey: .substitute)
        try? container.encode(type,         forKey: .type)
        try? container.encode(observed,     forKey: .observed)
        try? container.encode(nameLocal,    forKey: .nameLocal)
        try? container.encode(end,          forKey: .end)
        try? container.encode(start,        forKey: .start)
        try? container.encode(name,         forKey: .name)
        try? container.encode(isPublic,     forKey: .isPublic)
    }
}

class Weekday: Codable {
    var date     : HolidayDate?
    var observed : Observed?

    private enum CodingKeys: String, CodingKey {
        case date     = "date"
        case observed = "observed"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date     = try? container.decode(HolidayDate.self,     forKey: .date)
        observed = try? container.decode(Observed.self, forKey: .observed)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(date,     forKey: .date)
        try? container.encode(observed, forKey: .observed)
    }
}

class HolidayDate: Codable {
    var numeric: Int?
    var name   : String?

    private enum CodingKeys: String, CodingKey {
        case numeric = "numeric"
        case name    = "name"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        numeric = try? container.decode(Int.self,    forKey: .numeric)
        name    = try? container.decode(String.self, forKey: .name)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(numeric, forKey: .numeric)
        try? container.encode(name,    forKey: .name)
    }
}

class Observed: Codable {
    var numeric: Int?
    var name: String?

    private enum CodingKeys: String, CodingKey {
        case numeric = "numeric"
        case name    = "name"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        numeric = try? container.decode(Int.self,    forKey: .numeric)
        name    = try? container.decode(String.self, forKey: .name)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(numeric, forKey: .numeric)
        try? container.encode(name,    forKey: .name)
    }
}
