//
//  LearnCategory.swift
//  Explore
//
//  Created by Andrey Chernyshev on 20.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

struct LearnCategory {
    let name: String
    let thumbUrl: String
    let articles: [LearnArticle]
}

// MARK: Model

extension LearnCategory: Model {
    private enum Keys: String, CodingKey {
        case name
        case thumbUrl = "thumb"
        case articles
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        name = try container.decode(String.self, forKey: .name)
        thumbUrl = try container.decode(String.self, forKey: .thumbUrl)
        articles = try container.decode([LearnArticle].self, forKey: .articles)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(thumbUrl, forKey: .thumbUrl)
        try container.encode(articles, forKey: .articles)
    }
}
