//
//  model.swift
//  Webonise
//
//  Created by Uday Mishra on 27/03/19.
//  Copyright © 2019 Uday Mishra. All rights reserved.
//

import Foundation

struct ResponseModel: Decodable {
    let message: String
    let list: [List]
    let count: Int
    let cod: String
}

struct List: Decodable {
    let id: Int
    let name: String
    let wind: Wind
    let snow: JSONNull?
    let coord: Coord
    let rain: JSONNull?
    let sys: Sys
    let weather: [Weather]
    let clouds: Clouds
    let dt: Int
    let main: MainClass
}

struct Clouds: Decodable {
    let all: Int
}

struct Coord: Decodable {
    let lat, lon: Double
}

struct MainClass: Decodable {
    let tempMin, humidity: Int
    let temp: Double
    let tempMax, pressure: Int
    
    enum CodingKeys: String, CodingKey {
        case tempMin = "temp_min"
        case humidity, temp
        case tempMax = "temp_max"
        case pressure
    }
}

struct Sys: Decodable {
    let country: String
}

struct Weather: Decodable {
    let main: MainEnum
    let id: Int
    let description: Description
    let icon: Icon
}

enum Description: String, Decodable {
    case skyIsClear = "Sky is Clear"
}

enum Icon: String, Decodable {
    case the01N = "01n"
}

enum MainEnum: String, Decodable {
    case clear = "Clear"
}

struct Wind: Decodable {
    let speed: Double
    let deg: Int?
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
