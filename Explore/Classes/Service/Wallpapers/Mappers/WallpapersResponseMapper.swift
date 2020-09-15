//
//  WallpapersResponseMapper.swift
//  Explore
//
//  Created by Andrey Chernyshev on 15.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

final class WallpapersResponseMapper {
    static func map(response: Any) -> Wallpapers? {
        guard let model = WallpapersResponse.parseFromDictionary(any: response) else {
            return nil
        }
        
        return model.wallpapers
    }
}

private struct WallpapersResponse: Model {
    let wallpapers: Wallpapers
    
    enum Keys: String, CodingKey {
        case data = "_data"
        case list = "wallpapers"
        case hash = "wallpapers_hash"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        let data = try container.nestedContainer(keyedBy: Keys.self, forKey: .data)
        
        let list = try data.decode([Wallpaper].self, forKey: .list)
        let hash = try data.decode(String.self, forKey: .hash)
        
        wallpapers = Wallpapers(list: list, hash: hash)
    }
}
