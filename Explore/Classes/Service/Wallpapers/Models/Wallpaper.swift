//
//  Wallpaper.swift
//  Explore
//
//  Created by Andrey Chernyshev on 15.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

struct Wallpaper {
    let id: Int
    let sort: Int
    let thumbUrl: String
    let imageUrl: String
    let hash: String
}

extension Wallpaper: Model {
    private enum Keys: String, CodingKey {
        case id
        case sort
        case thumbUrl = "thumb_image_url"
        case imageUrl = "image_url"
        case hash
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        sort = try container.decode(Int.self, forKey: .sort)
        thumbUrl = try container.decode(String.self, forKey: .thumbUrl)
        imageUrl = try container.decode(String.self, forKey: .imageUrl)
        hash = try container.decode(String.self, forKey: .hash)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(sort, forKey: .sort)
        try container.encode(thumbUrl, forKey: .thumbUrl)
        try container.encode(imageUrl, forKey: .imageUrl)
        try container.encode(hash, forKey: .hash)
    }
}
