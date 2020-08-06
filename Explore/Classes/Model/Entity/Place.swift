//
//  Place.swift
//  Explore
//
//  Created by Andrey Chernyshev on 06.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

struct Place {
    let imageUrl: String
    let about: String
    let coordinate: Coordinate
}

extension Place: Model {
    private enum Keys: String, CodingKey {
        case imageUrl
        case about
        case latitude
        case longitude
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        imageUrl = try container.decode(String.self, forKey: .imageUrl)
        about = try container.decode(String.self, forKey: .about)
        
        
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        coordinate = Coordinate(latitude: latitude, longitude: longitude)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        
        try container.encode(imageUrl, forKey: .imageUrl)
        try container.encode(about, forKey: .about)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
    }
}
