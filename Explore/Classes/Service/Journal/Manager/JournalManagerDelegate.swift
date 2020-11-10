//
//  JournalManagerDelegate.swift
//  Explore
//
//  Created by Andrey Chernyshev on 10.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

protocol JournalManagerDelegate: class {
    func journalManagerDidStored(articles: [JournalArticle])
    func journalManagerDidStored(tags: [JournalTag])
    func journalManagerDidCreated(articleDetails: JournalArticleDetails)
    func journalManagerDidRemoved(articleId: Int)
}

extension JournalManagerDelegate {
    func journalManagerDidStored(articles: [JournalArticle]) {}
    func journalManagerDidStored(tags: [JournalTag]) {}
    func journalManagerDidCreated(articleDetails: JournalArticleDetails) {}
    func journalManagerDidRemoved(articleId: Int) {}
}
