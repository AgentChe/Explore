//
//  WallpapersManager.swift
//  Explore
//
//  Created by Andrey Chernyshev on 15.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift
import RxCocoa

protocol WallpapersManager: class {
    // MARK: API
    
    func getWallpapers() -> Wallpapers?
    func getWallpaper(id: Int) -> Wallpaper?
    func clearCache()
    func hasCachedWallpapers() -> Bool
    
    // MARK: API(Rx)
    
    func rxGetWallpapers(forceUpdate: Bool) -> Single<Wallpapers?>
    func rxGetWallpaper(id: Int) -> Single<Wallpaper?>
    func rxClearCache() -> Completable
    func rxHasCachedWallpapers() -> Single<Bool>
    
    // MARK: Trigger(Rx)
    
    var rxUpdatedWallpapersTrigger: Signal<Void> { get }
    var rxCacheClearedTrigger: Signal<Void> { get }
    
    // MARK: Observer
    
    func add(observer: WallpapersManagerDelegate)
    func remove(observer: WallpapersManagerDelegate)
}
