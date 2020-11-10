//
//  GetJournalTagsResponseMapper.swift
//  Explore
//
//  Created by Andrey Chernyshev on 10.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import Foundation

final class GetJournalTagsResponseMapper {
    static func map(from response: Any) -> [JournalTag] {
        guard
            let json = response as? [String: Any],
            let data = try? JSONSerialization.data(withJSONObject: json, options: []),
            let response = try? JSONDecoder().decode(Response.self, from: data)
        else {
            return []
        }
        
        return response.tags
    }
}

// MARK: Response
private struct Response: Decodable {
    let tags: [JournalTag]
    
    enum Keys: String, CodingKey {
        case data = "_data"
        case tags
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        let data = try container.nestedContainer(keyedBy: Keys.self, forKey: .data)
        
        tags = try data.decode([JournalTag].self, forKey: .tags)
    }
}
