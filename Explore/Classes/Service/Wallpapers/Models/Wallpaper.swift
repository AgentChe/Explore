//
//  Wallpaper.swift
//  Explore
//
//  Created by Andrey Chernyshev on 15.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

struct Wallpaper {
    let id: Int
    let paid: Bool
    let thumbUrl: String
    let imageUrl: String
}

// MARK: Codable
extension Wallpaper: Codable {
    private enum Keys: String, CodingKey {
        case id
        case paid
        case thumbUrl = "thumb_image_url"
        case imageUrl = "image_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        paid = try container.decode(Bool.self, forKey: .paid)
        thumbUrl = try container.decode(String.self, forKey: .thumbUrl)
        imageUrl = try container.decode(String.self, forKey: .imageUrl)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(paid, forKey: .paid)
        try container.encode(thumbUrl, forKey: .thumbUrl)
        try container.encode(imageUrl, forKey: .imageUrl)
    }
}
