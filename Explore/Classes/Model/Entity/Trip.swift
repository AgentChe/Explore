//
//  Trip.swift
//  Explore
//
//  Created by Andrey Chernyshev on 26.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

struct Trip {
    let toCoordinate: Coordinate
}

// MARK: Make

extension Trip: Model {
    private enum Keys: String, CodingKey {
        case toCoordinate
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        toCoordinate = try container.decode(Coordinate.self, forKey: .toCoordinate)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        
        try container.encode(toCoordinate, forKey: .toCoordinate)
    }
}
