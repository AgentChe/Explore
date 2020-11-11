//
//  BridgeArticleDetails.swift
//  Explore
//
//  Created by Andrey Chernyshev on 10.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

final class BridgeArticleDetails {
    func bridge(_ details: JournalArticleDetails) -> JournalArticle {
        JournalArticle(id: details.id,
                       tripId: details.tripId,
                       title: details.title,
                       rating: details.rating,
                       description: details.description,
                       tags: details.tags,
                       dateTime: details.dateTime,
                       tripTime: details.tripTime,
                       originImages: details.originImages,
                       thumbsImages: details.thumbsImages)
    }
}
