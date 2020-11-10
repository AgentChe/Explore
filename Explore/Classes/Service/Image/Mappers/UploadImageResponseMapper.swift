//
//  UploadImageResponseMapper.swift
//  Explore
//
//  Created by Andrey Chernyshev on 10.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import Foundation

final class UploadImageResponseMapper {
    static func map(from response: Any) -> Image? {
        guard
            let json = response as? [String: Any],
            let data = try? JSONSerialization.data(withJSONObject: json, options: []),
            let response = try? JSONDecoder().decode(Response.self, from: data)
        else {
            return nil
        }
        
        return response.image
    }
}

// MARK: Response
private struct Response: Decodable {
    let image: Image
    
    enum Keys: String, CodingKey {
        case _data
        case id
        case url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        let data = try container.nestedContainer(keyedBy: Keys.self, forKey: ._data)
        
        let id = try data.decode(Int.self, forKey: .id)
        let url = try data.decode(String.self, forKey: .url)
        
        image = Image(id: id, url: url)
    }
}
