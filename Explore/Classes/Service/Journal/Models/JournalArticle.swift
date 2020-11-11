//
//  JournalArticle.swift
//  Explore
//
//  Created by Andrey Chernyshev on 06.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

struct JournalArticle {
    let id: Int
    let tripId: Int
    let title: String
    let rating: Int 
    let description: String
    let tags: [JournalTag]
    let dateTime: String
    let tripTime: Int // секунды
    let originImages: [JournalImage]
    let thumbsImages: [JournalImage]
}

// MARK: Codable
extension JournalArticle: Codable {}
