//
//  JournalMediator.swift
//  Explore
//
//  Created by Andrey Chernyshev on 12.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift
import RxCocoa

final class JournalMediator {
    static let shared = JournalMediator()
    
    private var delegates = [Weak<JournalManagerDelegate>]()
    
    private let rxDidStoredArticlesTrigger = PublishRelay<[JournalArticle]>()
    private let rxDidStoredTagsTrigger = PublishRelay<[JournalTag]>()
    private let rxDidCreatedArticleDetailsTrigger = PublishRelay<JournalArticleDetails>()
    private let rxDidRemovedArticleIdTrigger = PublishRelay<Int>()
    
    private init() {}
}

// MARK: API
extension JournalMediator {
    func notifyAboutStored(articles: [JournalArticle]) {
        DispatchQueue.main.async {
            self.delegates.forEach { $0.weak?.journalManagerDidStored(articles: articles) }
            
            self.rxDidStoredArticlesTrigger.accept(articles)
        }
    }
    
    func notifyAboutStored(tags: [JournalTag]) {
        DispatchQueue.main.async {
            self.delegates.forEach { $0.weak?.journalManagerDidStored(tags: tags) }
            
            self.rxDidStoredTagsTrigger.accept(tags)
        }
    }
    
    func notifyAboutCreated(articleDetails: JournalArticleDetails) {
        DispatchQueue.main.async {
            self.delegates.forEach { $0.weak?.journalManagerDidCreated(articleDetails: articleDetails) }
            
            self.rxDidCreatedArticleDetailsTrigger.accept(articleDetails)
        }
    }
    
    func notifyAboutRemoved(articleId: Int) {
        DispatchQueue.main.async {
            self.delegates.forEach { $0.weak?.journalManagerDidRemoved(articleId: articleId)}
            
            self.rxDidRemovedArticleIdTrigger.accept(articleId)
        }
    }
}

// MARK: Triggers(Rx)
extension JournalMediator {
    var rxDidStoredArticles: Signal<[JournalArticle]> {
        rxDidStoredArticlesTrigger.asSignal()
    }
    
    var rxDidStoredTags: Signal<[JournalTag]> {
        rxDidStoredTagsTrigger.asSignal()
    }
    
    var rxDidCreatedArticleDetails: Signal<JournalArticleDetails> {
        rxDidCreatedArticleDetailsTrigger.asSignal()
    }
    
    var rxDidRemovedArticleId: Signal<Int> {
        rxDidRemovedArticleIdTrigger.asSignal()
    }
}

// MARK: Observer
extension JournalMediator {
    func add(observer: JournalManagerDelegate) {
        let weakly = observer as AnyObject
        delegates.append(Weak<JournalManagerDelegate>(weakly))
        delegates = delegates.filter { $0.weak != nil }
    }
    
    func remove(observer: JournalManagerDelegate) {
        if let index = delegates.firstIndex(where: { $0.weak === observer }) {
            delegates.remove(at: index)
        }
    }
}
