//
//  model.swift
//  Webonise
//
//  Created by Uday Mishra on 27/03/19.
//  Copyright © 2019 Uday Mishra. All rights reserved.
//

import Foundation

struct ResponseModel: Decodable {
    let message, cod: String
    let count: Int
    let list: [List]
}

struct List: Decodable {
    let id: Int
    let name: String
    let coord: Coord
    let main: MainClass
    let dt: Int
    let wind: Wind
    let sys: Sys
    let rain, snow: JSONNull?
    let clouds: Clouds
    let weather: [Weather]
}

struct Clouds: Decodable {
    let all: Int
}

struct Coord: Decodable {
    let lat, lon: Double
}

struct MainClass: Decodable {
    let temp: Double?
    let pressure, humidity, tempMin, tempMax: Int?
    
    enum CodingKeys: String, CodingKey {
        case temp, pressure, humidity
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

struct Sys: Decodable {
    let country: String
}

struct Weather: Decodable {
    let id: Int
    let main: MainEnum
    let description: Description
    let icon: Icon
}

enum Description: String, Decodable {
    case haze = "haze"
}

enum Icon: String, Decodable {
    case the50N = "50n"
}

enum MainEnum: String, Decodable {
    case haze = "Haze"
}

struct Wind: Decodable {
    let speed, deg: Double
}

// MARK: Encode/decode helpers

class JSONNull: Decodable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
