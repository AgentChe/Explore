//
//  Coordinate.swift
//  Explore
//
//  Created by Andrey Chernyshev on 05.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

struct Coordinate {
    let latitude: Double
    let longitude: Double
}

// MARK: Codable

extension Coordinate: Codable {
    private enum Keys: String, CodingKey {
        case latitude
        case longitude
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        latitude = try container.decode(Double.self, forKey: .latitude)
        longitude = try container.decode(Double.self, forKey: .longitude)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
}
