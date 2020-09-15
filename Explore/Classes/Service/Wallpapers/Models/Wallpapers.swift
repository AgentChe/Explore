//
//  Wallpapers.swift
//  Explore
//
//  Created by Andrey Chernyshev on 15.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

struct Wallpapers {
    let list: [Wallpaper]
    let hash: String
}

extension Wallpapers: Model {
    private enum Keys: String, CodingKey {
        case list = "wallpapers"
        case hash = "wallpapers_hash"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        list = try container.decode([Wallpaper].self, forKey: .list)
        hash = try container.decode(String.self, forKey: .hash)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        
        try container.encode(list, forKey: .list)
        try container.encode(hash, forKey: .hash)
    }
}
