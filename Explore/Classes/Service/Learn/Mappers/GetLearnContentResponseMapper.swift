//
//  GetLearnContentResponseMapper.swift
//  Explore
//
//  Created by Andrey Chernyshev on 20.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import Foundation.NSJSONSerialization

final class GetLearnContentResponseMapper {
    static func map(response: Any) -> LearnContent? {
        guard
            let data = try? JSONSerialization.data(withJSONObject: response, options: []),
            let model = try? JSONDecoder().decode(GetLearnContentResponse.self, from: data)
        else {
            return nil
        }
        
        return model.content
    }
}

private struct GetLearnContentResponse: Decodable {
    let content: LearnContent
    
    enum Keys: String, CodingKey {
        case data = "_data"
        case name
        case imageUrl = "image"
        case text
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        let data = try container.nestedContainer(keyedBy: Keys.self, forKey: .data)
        
        let name = try data.decode(String.self, forKey: .name)
        let imageUrl = try data.decode(String.self, forKey: .imageUrl)
        let text = try data.decode(String.self, forKey: .text)
        
        content = LearnContent(name: name,
                               imageUrl: imageUrl,
                               text: text)
    }
}
