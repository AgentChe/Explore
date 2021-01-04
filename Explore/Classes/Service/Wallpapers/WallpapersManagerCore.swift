//
//  WallpapersManagerCore.swift
//  Explore
//
//  Created by Andrey Chernyshev on 15.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift
import RxCocoa

final class WallpapersManagerCore: WallpapersManager {
    private struct Constants {
        static let categoriesCacheKey = "wallpapers_manager_core_categories_cache_key"
    }
}

// MARK: API(Rx)
extension WallpapersManagerCore {
    func rxGetWallpaperCategories(forceUpdate: Bool) -> Single<WallpaperCategories> {
        forceUpdate ? retrieveWallpaperCategories() : .deferred { [weak self] in
            guard let this = self else {
                return .never()
            }
            
            return .just(this.getCachedCategories())
        }
    }
    
    func rxGetWallpapers(categoryId: Int, forceUpdate: Bool) -> Single<[Wallpaper]> {
        rxGetWallpaperCategories(forceUpdate: forceUpdate)
            .map { categories -> [Wallpaper] in
                categories
                    .categories
                    .first(where: { $0.id == categoryId })?
                    .wallpapers ?? []
            }
    }
    
    func rxGetWallpaperCategory(categoryId: Int, forceUpdate: Bool) -> Single<WallpaperCategory?> {
        rxGetWallpaperCategories(forceUpdate: forceUpdate)
            .map { categories -> WallpaperCategory? in
                categories
                    .categories
                    .first(where: { $0.id == categoryId })
            }
    }
}

// MARK: Private
private extension WallpapersManagerCore {
    func getCachedCategories() -> WallpaperCategories {
        guard
            let data = UserDefaults.standard.data(forKey: Constants.categoriesCacheKey),
            let categories = try? JSONDecoder().decode(WallpaperCategories.self, from: data)
        else {
            return WallpaperCategories(categories: [], newArrivals: [])
        }
        
        return categories
    }
    
    func retrieveWallpaperCategories() -> Single<WallpaperCategories> {
        let userToken = SessionManager.shared.getSession()?.userToken
        let request = GetWallpapersRequest(userToken: userToken)
        
        return SDKStorage.shared
            .restApiTransport
            .callServerApi(requestBody: request)
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .map { GetWallpapersResponseMapper.map(from: $0) }
            .observe(on: MainScheduler.asyncInstance)
            .do(onSuccess: { [weak self] categories in
                self?.store(categories: categories)
            })
    }
    
    @discardableResult
    func store(categories: WallpaperCategories) -> Bool {
        guard let data = try? JSONEncoder().encode(categories) else {
            return false
        }
        
        UserDefaults.standard.set(data, forKey: Constants.categoriesCacheKey)
        
        return true 
    }
}
