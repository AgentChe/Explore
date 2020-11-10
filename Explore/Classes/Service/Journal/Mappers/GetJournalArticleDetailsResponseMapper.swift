//
//  GetJournalArticleDetailsResponseMapper.swift
//  Explore
//
//  Created by Andrey Chernyshev on 10.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import Foundation

final class GetJournalArticleDetailsResponseMapper {
    static func map(from response: Any, tags: [JournalTag]) -> JournalArticleDetails? {
        guard
            let json = response as? [String: Any],
            let data = try? JSONSerialization.data(withJSONObject: json, options: []),
            let response = try? JSONDecoder().decode(Response.self, from: data)
        else {
            return nil
        }
        
        let responseArticle = response.article
            
        let articleTags = tags.filter { responseArticle.tags.contains($0.id) }
        let articleImages = responseArticle.images.map { JournalImage(id: $0.id,
                                                                      thumbPath: $0.thumb,
                                                                      originalPath: nil) }
            
        return JournalArticleDetails(id: responseArticle.id,
                                     tripId: responseArticle.location_id,
                                     title: responseArticle.title,
                                     rating: responseArticle.rating,
                                     description: responseArticle.description,
                                     tags: articleTags,
                                     timestamp: responseArticle.timestamp,
                                     tripTime: responseArticle.trip_time,
                                     images: articleImages,
                                     sharePath: responseArticle.share_url)
    }
}

// MARK: Response
private struct Response: Decodable {
    let article: ResponseArticle
    
    enum Keys: String, CodingKey {
        case _data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        article = try container.decode(ResponseArticle.self, forKey: ._data)
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
    let timestamp: TimeInterval
    let trip_time: Int
    let images: [ResponseImage]
    let share_url: String
}

// MARK: ResponseImage
private struct ResponseImage: Decodable {
    let id: Int
    let thumb: String
    let full: String
}
