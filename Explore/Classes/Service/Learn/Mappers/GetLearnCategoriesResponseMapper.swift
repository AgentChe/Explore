//
//  GetLearnCategoriesResponseMapper.swift
//  Explore
//
//  Created by Andrey Chernyshev on 20.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import Foundation.NSJSONSerialization

final class GetLearnCategoriesResponseMapper {
    static func map(response: Any) -> [LearnCategory] {
        guard
            let data = try? JSONSerialization.data(withJSONObject: response, options: []),
            let model = try? JSONDecoder().decode(GetLearnCategoriesResponse.self, from: data)
        else {
            return []
        }
        
        return model.categories
    }
}

private struct GetLearnCategoriesResponse: Decodable {
    let categories: [LearnCategory]
    
    enum Keys: String, CodingKey {
        case data = "_data"
        case categories = "categories"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        let data = try container.nestedContainer(keyedBy: Keys.self, forKey: .data)
        
        categories = try data.decode([LearnCategory].self, forKey: .categories)
    }
}
