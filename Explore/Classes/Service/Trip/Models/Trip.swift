//
//  Trip.swift
//  Explore
//
//  Created by Andrey Chernyshev on 26.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

struct Trip {
    let id: Int
    let toCoordinate: Coordinate
}

// MARK: Make

extension Trip: Model {
    private enum Keys: String, CodingKey {
        case id
        case toCoordinate
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        toCoordinate = try container.decode(Coordinate.self, forKey: .toCoordinate)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(toCoordinate, forKey: .toCoordinate)
    }
}
