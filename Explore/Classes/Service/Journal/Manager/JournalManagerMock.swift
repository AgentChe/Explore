//
//  JournalManagerMock.swift
//  Explore
//
//  Created by Andrey Chernyshev on 10.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift
import RxCocoa

final class JournalManagerMock: JournalManager {
    struct Constants {
        static let cachedArticlesKey = "journal_manager_mock_cached_articles_key"
        static let cachedTagsKey = "journal_manager_mock_cached_tags_key"
    }
    
    private var delegates = [Weak<JournalManagerDelegate>]()
    
    private let rxDidStoredArticlesTrigger = PublishRelay<[JournalArticle]>()
    private let rxDidStoredTagsTrigger = PublishRelay<[JournalTag]>()
    private let rxDidCreatedArticleDetailsTrigger = PublishRelay<JournalArticleDetails>()
    private let rxDidRemovedArticleIdTrigger = PublishRelay<Int>()
}

// MARK: API(Rx)
extension JournalManagerMock {
    func rxRetrieveArticles(forceUpdate: Bool) -> Single<[JournalArticle]> {
        forceUpdate ? loadArticles() : getCachedList(key: Constants.cachedArticlesKey)
    }
    
    func rxRetrieveTags(forceUpdate: Bool) -> Single<[JournalTag]> {
        forceUpdate ? loadTags() : getCachedList(key: Constants.cachedTagsKey)
    }
    
    func rxObtainArticleDetails(id: Int, useCachedTags: Bool = true) -> Single<JournalArticleDetails?> {
        Single
            .zip(
                .deferred {
                    .just(self.getJSON(with: "GetJournalArticleDetailsRequestJSON"))
                },
                
                useCachedTags ? getCachedList(key: Constants.cachedTagsKey) : loadTags()
            )
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map { GetJournalArticleDetailsResponseMapper.map(from: $0, tags: $1) }
            .observeOn(MainScheduler.asyncInstance)
            .delay(RxTimeInterval.seconds(1), scheduler: MainScheduler.asyncInstance)
    }
    
    func rxCreate(tripId: Int,
                  title: String,
                  rating: Int,
                  description: String?,
                  tagsIds: [Int]?,
                  originImagesIds: [Int]?,
                  thumbsImagesIds: [Int]?,
                  imagesIdsToDelete: [Int]?) -> Single<JournalArticleDetails?> {
        Single
            .zip(
                .deferred {
                    .just(self.getJSON(with: "SaveJournalArticleRequestJSON"))
                },
                
                getCachedList(key: Constants.cachedTagsKey)
            )
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map { SaveJournalArticleResponseMapper.map(from: $0, tags: $1) }
            .observeOn(MainScheduler.asyncInstance)
            .do(onSuccess: { [weak self] createdArticleDetails in
                guard let details = createdArticleDetails else {
                    return
                }
                
                self?.appendToArticlesCache(details: details)
            })
            .delay(RxTimeInterval.seconds(1), scheduler: MainScheduler.asyncInstance)
    }
    
    func rxDelete(articleId: Int) -> Completable {
        Completable
            .create { event in
                DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 1) {
                    DispatchQueue.main.async {
                        event(.completed)
                    }
                }
                
                return Disposables.create()
            }
            .do(onCompleted: { [weak self] in
                self?.removeFromArticlesCache(articleId: articleId)
            })
    }
}

// MARK: Triggers(Rx)
extension JournalManagerMock {
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
extension JournalManagerMock {
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

// MARK: Private
private extension JournalManagerMock {
    func getJSON(with name: String) -> Any {
        guard
            let url = Bundle.main.url(forResource: name, withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        else {
            return [:]
        }
        
        return json
    }
    
    func getCachedList<T: Decodable>(key: String) -> Single<[T]> {
        Single<[T]>
            .create { event in
                guard
                    let data = UserDefaults.standard.data(forKey: key),
                    let models = try? JSONDecoder().decode([T].self, from: data)
                else {
                    return Disposables.create()
                }
                
                event(.success(models))
                
                return Disposables.create()
            }
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.asyncInstance)
    }
    
    func loadArticles() -> Single<[JournalArticle]> {
        Single
            .zip(
                .deferred {
                    .just(self.getJSON(with: "GetJournalListRequestJSON"))
                },
                
                loadTags()
            )
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map { GetJournalListResponseMapper.map(from: $0, tags: $1) }
            .observeOn(MainScheduler.asyncInstance)
            .do(onSuccess: { [weak self] articles in
                self?.store(articles: articles)
            })
            .delay(RxTimeInterval.seconds(1), scheduler: MainScheduler.asyncInstance)
    }
    
    func store(articles: [JournalArticle]) {
        DispatchQueue.global().async {
            guard let data = try? JSONEncoder().encode(articles) else {
                return
            }
            
            UserDefaults.standard.setValue(data, forKey: Constants.cachedArticlesKey)
            
            DispatchQueue.main.async { [weak self] in
                self?.delegates.forEach { $0.weak?.journalManagerDidStored(articles: articles) }
                
                self?.rxDidStoredArticlesTrigger.accept(articles)
            }
        }
    }
    
    func loadTags() -> Single<[JournalTag]> {
        Single<Any>
            .create { event in
                event(.success(self.getJSON(with: "GetJournalTagsRequestJSON")))
                
                return Disposables.create()
            }
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map { GetJournalTagsResponseMapper.map(from: $0) }
            .observeOn(MainScheduler.asyncInstance)
            .do(onSuccess: { [weak self] tags in
                self?.store(tags: tags)
            })
    }
    
    func store(tags: [JournalTag]) {
        DispatchQueue.global().async {
            guard let data = try? JSONEncoder().encode(tags) else {
                return
            }
            
            UserDefaults.standard.setValue(data, forKey: Constants.cachedTagsKey)
            
            DispatchQueue.main.async { [weak self] in
                self?.delegates.forEach { $0.weak?.journalManagerDidStored(tags: tags) }
                
                self?.rxDidStoredTagsTrigger.accept(tags)
            }
        }
    }
    
    func appendToArticlesCache(details: JournalArticleDetails) {
        DispatchQueue.global().async { [weak self] in
            guard
                let data = UserDefaults.standard.data(forKey: Constants.cachedArticlesKey),
                var articles = try? JSONDecoder().decode([JournalArticle].self, from: data)
            else {
                return
            }
            
            let article = BridgeArticleDetails().bridge(details)
            
            articles.append(article)
            
            self?.store(articles: articles)
            
            DispatchQueue.main.async {
                self?.rxDidCreatedArticleDetailsTrigger.accept(details)
            }
        }
    }
    
    func removeFromArticlesCache(articleId: Int) {
        DispatchQueue.global().async { [weak self] in
            guard
                let data = UserDefaults.standard.data(forKey: Constants.cachedArticlesKey),
                var articles = try? JSONDecoder().decode([JournalArticle].self, from: data)
            else {
                return
            }
            
            articles.removeAll(where: { $0.id == articleId })
            
            self?.store(articles: articles)
            
            DispatchQueue.main.async {
                self?.rxDidRemovedArticleIdTrigger.accept(articleId)
            }
        }
    }
}

