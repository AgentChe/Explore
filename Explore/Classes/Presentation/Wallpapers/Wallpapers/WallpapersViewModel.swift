//
//  WallpapersViewModel.swift
//  Explore
//
//  Created by Andrey Chernyshev on 15.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift
import RxCocoa

final class WallpapersViewModel {
    private let wallpapersManager = WallpapersManagerCore()
    private let sessionManager = SessionManager.shared
    
    func section(for categoryId: Int) -> Driver<WallpaperCollectionSection> {
        let category = wallpapersManager
            .rxGetWallpaperCategory(categoryId: categoryId, forceUpdate: false)
            .asDriver(onErrorJustReturn: nil)
        
        let activeSubscription = hasActiveSubscription()
        
        return Driver
            .combineLatest(category, activeSubscription)
            .compactMap { [weak self] category, activeSubscription -> WallpaperCollectionSection? in
                guard let this = self else {
                    return nil
                }
                
                return this.map(category: category, hasActiveSubscription: activeSubscription)
            }
    }
}

// MARK: Private
private extension WallpapersViewModel {
    func map(category: WallpaperCategory?, hasActiveSubscription: Bool) -> WallpaperCollectionSection? {
        guard let category = category else {
            return nil
        }
        
        let elements = category.wallpapers
            .map { wallpaper -> WallpaperCollectionElement in
                WallpaperCollectionElement(wallpaper: wallpaper, hasActiveSubscription: hasActiveSubscription)
            }
        
        return WallpaperCollectionSection(title: category.name,
                                          elements: elements)
    }
    
    func hasActiveSubscription() -> Driver<Bool> {
        let initial = sessionManager.rx.getSession()
            .map { $0?.activeSubscription ?? false }
            .asDriver(onErrorJustReturn: false)
        
        let updated = sessionManager
            .didStoredSession
            .map { $0.activeSubscription }
            .asDriver(onErrorJustReturn: false)
        
        return Driver
            .merge(initial, updated)
    }
}
