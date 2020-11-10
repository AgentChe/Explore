//
//  SaveJournalArticleResponseMapper.swift
//  Explore
//
//  Created by Andrey Chernyshev on 10.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

final class SaveJournalArticleResponseMapper {
    static func map(from response: Any, tags: [JournalTag]) -> JournalArticleDetails? {
        GetJournalArticleDetailsResponseMapper.map(from: response, tags: tags)
    }
}
