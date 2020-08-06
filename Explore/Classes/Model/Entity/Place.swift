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
}

extension Place: Model {
    private enum Keys: String, CodingKey {
        case imageUrl
        case about
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        imageUrl = try container.decode(String.self, forKey: .imageUrl)
        about = try container.decode(String.self, forKey: .about)
    }
}
