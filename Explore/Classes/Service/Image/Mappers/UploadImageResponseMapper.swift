//
//  UploadImageResponseMapper.swift
//  Explore
//
//  Created by Andrey Chernyshev on 10.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import Foundation

final class UploadImageResponseMapper {
    static func map(from response: Any) -> Picture? {
        guard
            let json = response as? [String: Any],
            let data = try? JSONSerialization.data(withJSONObject: json, options: []),
            let response = try? JSONDecoder().decode(Response.self, from: data)
        else {
            return nil
        }
        
        return response.picture
    }
}

// MARK: Response
private struct Response: Decodable {
    let picture: Picture
    
    enum Keys: String, CodingKey {
        case _data
        case image
        case thumb
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        let data = try container.nestedContainer(keyedBy: Keys.self, forKey: ._data)
        
        let image = try data.decode(Image.self, forKey: .image)
        let thumb = try data.decode(Image.self, forKey: .thumb)
        
        picture = Picture(thumb: thumb, origin: image)
    }
}
