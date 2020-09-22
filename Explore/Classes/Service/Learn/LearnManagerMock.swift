//
//  LearnManagerMock.swift
//  Explore
//
//  Created by Andrey Chernyshev on 20.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift

final class LearnManagerMock: LearnManager {
    struct Constants {
        static let categoriesCacheKey = "learn_manager_mock_categories_cache_key"
    }
}

// MARK: API

extension LearnManagerMock {
    func getCategories() -> [LearnCategory] {
        guard let data = UserDefaults.standard.data(forKey: Constants.categoriesCacheKey) else {
            return []
        }
        
        let categories = try? JSONDecoder().decode([LearnCategory].self, from: data)
        
        return categories ?? []
    }
    
    func hasCachedCategories() -> Bool {
        UserDefaults.standard.data(forKey: Constants.categoriesCacheKey) != nil
    }
}

// MARK: API (Rx)

extension LearnManagerMock {
    func rxGetCategories(forceUpdate: Bool) -> Single<[LearnCategory]> {
        if forceUpdate {
            return retrieveCategories()
        }
        
        if hasCachedCategories() {
            return .deferred { [weak self] in .just(self?.getCategories() ?? []) }
        } else {
            return retrieveCategories()
        }
    }
    
    func rxGetContent(articleId: Int) -> Single<LearnContent?> {
        retrieveContent(articleId: articleId)
    }
}

// MARK: Private

private extension LearnManagerMock {
    func retrieveCategories() -> Single<[LearnCategory]> {
        Single<Any>
            .create { event in
                guard
                    let url = Bundle.main.url(forResource: "GetLearnCategoriesRequestJSON", withExtension: "json"),
                    let data = try? Data(contentsOf: url),
                    let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                else {
                    event(.success([:]))
                
                    return Disposables.create()
                }
            
                event(.success(json))
            
                return Disposables.create()
            }
            .map { try ErrorChecker.throwErrorIfHas(from: $0) }
            .map { GetLearnCategoriesResponseMapper.map(response: $0) }
            .do(onSuccess: { [weak self] categories in
                self?.store(categories: categories)
            })
    }
    
    @discardableResult
    func store(categories: [LearnCategory]) -> Bool {
        guard let data = try? JSONEncoder().encode(categories) else {
            return false
        }
        
        UserDefaults.standard.set(data, forKey: Constants.categoriesCacheKey)
        
        return true
    }
    
    func retrieveContent(articleId: Int) -> Single<LearnContent?> {
        Single<Any>
            .create { event in
                guard
                    let url = Bundle.main.url(forResource: "GetLearnContentRequestJSON", withExtension: "json"),
                    let data = try? Data(contentsOf: url),
                    let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                else {
                    event(.success([:]))
                    
                    return Disposables.create()
                }
                
                event(.success(json))
                
                return Disposables.create()
            }
            .map { try ErrorChecker.throwErrorIfHas(from: $0) }
            .map { GetLearnContentResponseMapper.map(response: $0) }
    }
}
