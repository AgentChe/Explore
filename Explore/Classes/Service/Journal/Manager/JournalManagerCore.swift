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
                SDKStorage.shared
                    .restApiTransport
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
                  originImagesIds: [Int]?,
                  thumbsImagesIds: [Int]?,
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
                                                originImagesIds: originImagesIds,
                                                thumbsImagesIds: thumbsImagesIds,
                                                imagesIdsToDelete: imagesIdsToDelete)
        
        return Single
            .zip(
                SDKStorage.shared
                    .restApiTransport
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
        
        return SDKStorage.shared
            .restApiTransport
            .callServerApi(requestBody: request)
            .do(onSuccess: { [weak self] any in
                self?.removeFromArticlesCache(articleId: articleId)
            })
            .asCompletable()
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
                    event(.success([]))
                    
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
                SDKStorage.shared
                    .restApiTransport
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
            
            JournalMediator.shared.notifyAboutStored(articles: articles)
        }
    }
    
    func loadTags() -> Single<[JournalTag]> {
        guard let userToken = SessionManager.shared.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let getTagsRequest = GetJournalTagsRequest(userToken: userToken)
        
        return SDKStorage.shared
            .restApiTransport
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
            
            JournalMediator.shared.notifyAboutStored(tags: tags)
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
            
            JournalMediator.shared.notifyAboutCreated(articleDetails: details)
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
            
            JournalMediator.shared.notifyAboutRemoved(articleId: articleId)
        }
    }
}
