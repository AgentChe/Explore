//
//  JournalArticleDetails.swift
//  Explore
//
//  Created by Andrey Chernyshev on 06.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import Foundation

struct JournalArticleDetails {
    let id: Int
    let tripId: Int
    let title: String
    let rating: Int
    let description: String
    let tags: [JournalTag]
    let timestamp: TimeInterval
    let tripTime: Int // секунды
    let images: [JournalImage]
    let sharePath: String
}

// MARK: Codable
extension JournalArticleDetails: Codable {}
