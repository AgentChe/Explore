//
//  WallpaperCategory.swift
//  Explore
//
//  Created by Andrey Chernyshev on 21.12.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

struct WallpaperCategory {
    let id: Int
    let name: String
    let imageUrl: String
    let paid: Bool
    let wallpapersCount: Int
    let wallpapers: [Wallpaper]
}

// MARK: Decodable
extension WallpaperCategory: Codable {
    private enum Keys: String, CodingKey {
        case id
        case name
        case imageUrl = "image_url"
        case paid
        case wallpapersCount = "wallpapers_count"
        case wallpapers
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        imageUrl = try container.decode(String.self, forKey: .imageUrl)
        paid = try container.decode(Bool.self, forKey: .paid)
        wallpapersCount = try container.decode(Int.self, forKey: .wallpapersCount)
        wallpapers = try container.decode([Wallpaper].self, forKey: .wallpapers)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(imageUrl, forKey: .imageUrl)
        try container.encode(paid, forKey: .paid)
        try container.encode(wallpapersCount, forKey: .wallpapersCount)
        try container.encode(wallpapers, forKey: .wallpapers)
    }
}
