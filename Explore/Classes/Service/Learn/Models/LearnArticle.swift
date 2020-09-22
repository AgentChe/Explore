//
//  LearnArticle.swift
//  Explore
//
//  Created by Andrey Chernyshev on 20.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

struct LearnArticle {
    let id: Int
    let name: String
    let thumbUrl: String
}

// MARK: Model 

extension LearnArticle: Model {
    private enum Keys: String, CodingKey {
        case id
        case name
        case thumbUrl = "thumb"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        thumbUrl = try container.decode(String.self, forKey: .thumbUrl)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(thumbUrl, forKey: .thumbUrl)
    }
}
