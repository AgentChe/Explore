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
        static let wallpapersCacheKey = "wallpapers_manager_core_wallpapers_cache_key"
    }
    
    private var delegates = [Weak<WallpapersManagerDelegate>]()
    
    private let updatedWallpapersTrigger = PublishRelay<Void>()
    private let cacheClearedTrigger = PublishRelay<Void>()
}

// MARK: API

extension WallpapersManagerCore {
    func getWallpapers() -> Wallpapers? {
        guard let data = UserDefaults.standard.data(forKey: Constants.wallpapersCacheKey) else {
            return nil
        }
        
        return try? Wallpapers.parse(from: data)
    }
    
    func getWallpaper(id: Int) -> Wallpaper? {
        getWallpapers()?.list.first(where: { $0.id == id })
    }
    
    func clearCache() {
        removeAll()
    }
    
    func hasCachedWallpapers() -> Bool {
        UserDefaults.standard.data(forKey: Constants.wallpapersCacheKey) != nil
    }
}

// MARK: API(Rx)

extension WallpapersManagerCore {
    func rxGetWallpapers(forceUpdate: Bool) -> Single<Wallpapers?> {
        if forceUpdate {
            return retrieveWallpapers()
        }
        
        if hasCachedWallpapers() {
            return .deferred { [weak self] in .just(self?.getWallpapers()) }
        } else {
            return retrieveWallpapers()
        }
    }
    
    func rxGetWallpaper(id: Int) -> Single<Wallpaper?> {
        .deferred { [weak self] in .just(self?.getWallpaper(id: id)) }
    }
    
    func rxClearCache() -> Completable {
        .deferred { [weak self] in
            self?.clearCache()
            
            return .empty()
        }
    }
    
    func rxHasCachedWallpapers() -> Single<Bool> {
        .deferred { [weak self] in .just(self?.hasCachedWallpapers() ?? false) }
    }
}

// MARK: Trigger(Rx)

extension WallpapersManagerCore {
    var rxUpdatedWallpapersTrigger: Signal<Void> {
        updatedWallpapersTrigger.asSignal()
    }
    
    var rxCacheClearedTrigger: Signal<Void> {
        cacheClearedTrigger.asSignal()
    }
}

// MARK: Observer

extension WallpapersManagerCore {
    func add(observer: WallpapersManagerDelegate) {
        let weakly = observer as AnyObject
        delegates.append(Weak<WallpapersManagerDelegate>(weakly))
        delegates = delegates.filter { $0.weak != nil }
    }
    
    func remove(observer: WallpapersManagerDelegate) {
        if let index = delegates.firstIndex(where: { $0.weak === observer }) {
            delegates.remove(at: index)
        }
    }
}

// MARK: Private

private extension WallpapersManagerCore {
    func retrieveWallpapers() -> Single<Wallpapers?> {
        guard let userToken = SessionManager.shared.getSession()?.userToken else {
            return .deferred { .error(SignError.tokenNotFound) }
        }
        
        return SDKStorage.shared
            .restApiTransport
            .callServerApi(requestBody: GetWallpapersRequest(userToken: userToken))
            .map { try ErrorChecker.throwErrorIfHas(from: $0) }
            .map { WallpapersResponseMapper.map(response: $0) }
            .do(onSuccess: { [weak self] wallpapers in
                guard let this = self, let wallpapers = wallpapers else {
                    return
                }
                
                this.store(wallpapers: wallpapers)
            })
    }
    
    @discardableResult
    func store(wallpapers: Wallpapers) -> Bool {
        guard let data = try? Wallpapers.encode(object: wallpapers) else {
            return false
        }
        
        UserDefaults.standard.set(data, forKey: Constants.wallpapersCacheKey)
        
        updatedWallpapersTrigger.accept(Void())
        
        delegates.forEach { $0.weak?.wallpapersManagerDidUpdatedWallpapers() }
        
        return true 
    }
    
    @discardableResult
    func removeAll() -> Bool {
        UserDefaults.standard.removeObject(forKey: Constants.wallpapersCacheKey)
        
        cacheClearedTrigger.accept(Void())
        
        delegates.forEach { $0.weak?.wallpapersManagerDidChacheCleared() }
        
        return true
    }
}
