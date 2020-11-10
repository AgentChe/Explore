//
//  JournalManagerCore.swift
//  Explore
//
//  Created by Andrey Chernyshev on 10.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift
import RxCocoa

final class JournalManagerCore: JournalManager {
    struct Constants {
        static let cachedArticlesKey = "journal_manager_core_cached_articles_key"
        static let cachedTagsKey = "journal_manager_core_cached_tags_key"
    }
    
    private var delegates = [Weak<JournalManagerDelegate>]()
    
    private let rxDidStoredArticlesTrigger = PublishRelay<[JournalArticle]>()
    private let rxDidStoredTagsTrigger = PublishRelay<[JournalTag]>()
    private let rxDidCreatedArticleDetailsTrigger = PublishRelay<JournalArticleDetails>()
    private let rxDidRemovedArticleIdTrigger = PublishRelay<Int>()
}

// MARK: API(Rx)
extension JournalManagerCore {
    func rxRetrieveArticles(forceUpdate: Bool) -> Single<[JournalArticle]> {
        forceUpdate ? loadArticles() : getCachedList(key: Constants.cachedArticlesKey)
    }
    
    func rxRetrieveTags(forceUpdate: Bool) -> Single<[JournalTag]> {
        forceUpdate ? loadTags() : getCachedList(key: Constants.cachedTagsKey)
    }
    
    func rxObtainArticleDetails(id: Int, useCachedTags: Bool = true) -> Single<JournalArticleDetails?> {
        guard let userToken = SessionManager.shared.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let getArticleDetailsRequest = GetJournalArticleDetailsRequest(userToken: userToken, id: id)
        
        let tagsSuquence = useCachedTags ? getCachedList(key: Constants.cachedTagsKey) : loadTags()
        
        return Single
            .zip(
                RestAPITransport()
                    .callServerApi(requestBody: getArticleDetailsRequest),
                
                tagsSuquence
            )
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map { GetJournalArticleDetailsResponseMapper.map(from: $0, tags: $1) }
            .observeOn(MainScheduler.asyncInstance)
    }
    
    func rxCreate(tripId: Int,
                  title: String,
                  rating: Int,
                  description: String?,
                  tagsIds: [Int]?,
                  imagesIds: [Int]?,
                  imagesIdsToDelete: [Int]?) -> Single<JournalArticleDetails?> {
        guard let userToken = SessionManager.shared.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = SaveJournalArticleRequest(userToken: userToken,
                                                tripId: tripId,
                                                title: title,
                                                rating: rating,
                                                description: description,
                                                tagsIds: tagsIds,
                                                imagesIds: imagesIds,
                                                imagesIdsToDelete: imagesIdsToDelete)
        
        return Single
            .zip(
                RestAPITransport()
                    .callServerApi(requestBody: request),
                
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
    }
    
    func rxDelete(articleId: Int) -> Completable {
        guard let userToken = SessionManager.shared.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = DeleteJournalArticleRequest(userToken: userToken, articleId: articleId)
        
        return RestAPITransport()
            .callServerApi(requestBody: request)
            .do(onSuccess: { [weak self] any in
                self?.removeFromArticlesCache(articleId: articleId)
            })
            .asCompletable()
    }
}

// MARK: Triggers(Rx)
extension JournalManagerCore {
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
extension JournalManagerCore {
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
private extension JournalManagerCore {
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
        guard let userToken = SessionManager.shared.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let getArticlesRequest = GetJournalListRequest(userToken: userToken)
        
        return Single
            .zip(
                RestAPITransport()
                    .callServerApi(requestBody: getArticlesRequest),
                
                loadTags()
            )
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map { GetJournalListResponseMapper.map(from: $0, tags: $1) }
            .observeOn(MainScheduler.asyncInstance)
            .do(onSuccess: { [weak self] articles in
                self?.store(articles: articles)
            })
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
        guard let userToken = SessionManager.shared.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let getTagsRequest = GetJournalTagsRequest(userToken: userToken)
        
        return RestAPITransport()
            .callServerApi(requestBody: getTagsRequest)
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
