//
//  GetJournalListResponseMapper.swift
//  Explore
//
//  Created by Andrey Chernyshev on 10.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import Foundation

final class GetJournalListResponseMapper {
    static func map(from response: Any, tags: [JournalTag]) -> [JournalArticle] {
        guard
            let json = response as? [String: Any],
            let data = try? JSONSerialization.data(withJSONObject: json, options: []),
            let response = try? JSONDecoder().decode(Response.self, from: data)
        else {
            return []
        }
        
        return response
            .articles
            .map { responseArticle -> JournalArticle in
                let articleTags = tags.filter { responseArticle.tags.contains($0.id) }
                let articleOriginImages = responseArticle.images.map { JournalImage(id: $0.id, url: $0.url) }
                let articleThumbImages = responseArticle.thumbs.map { JournalImage(id: $0.id, url: $0.url) }
                
                return JournalArticle(id: responseArticle.id,
                               tripId: responseArticle.location_id,
                               title: responseArticle.title,
                               rating: responseArticle.rating,
                               description: responseArticle.description,
                               tags: articleTags,
                               dateTime: responseArticle.timestamp,
                               tripTime: responseArticle.trip_time,
                               originImages: articleOriginImages,
                               thumbsImages: articleThumbImages)
            }
    }
}

// MARK: Response
private struct Response: Decodable {
    let articles: [ResponseArticle]
    
    enum Keys: String, CodingKey {
        case _data
        case entries
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        let data = try container.nestedContainer(keyedBy: Keys.self, forKey: ._data)
        
        articles = try data.decode([ResponseArticle].self, forKey: .entries)
    }
}

// MARK: ResponseArticle
private struct ResponseArticle: Decodable {
    let id: Int
    let location_id: Int
    let title: String
    let rating: Int
    let description: String
    let tags: [Int]
    let timestamp: String
    let trip_time: Int
    let images: [ResponseImage]
    let thumbs: [ResponseImage]
}

// MARK: ResponseImage
private struct ResponseImage: Decodable {
    let id: Int
    let url: String
}
