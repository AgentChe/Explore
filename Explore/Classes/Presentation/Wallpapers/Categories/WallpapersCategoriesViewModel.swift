//
//  WallpapersCategoriesViewModel.swift
//  Explore
//
//  Created by Andrey Chernyshev on 21.12.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift
import RxCocoa

final class WallpapersCategoriesViewModel {
    private let wallpapersManager = WallpapersManagerCore()
    private let sessionManager = SessionManager.shared
    
    func sections() -> Driver<[WCCollectionSection]> {
        let cached = wallpapersManager
            .rxGetWallpaperCategories(forceUpdate: false)
            .asDriver(onErrorDriveWith: .empty())
        
        let downloaded = wallpapersManager
            .rxGetWallpaperCategories(forceUpdate: true)
            .asDriver(onErrorDriveWith: .empty())
        
        let categories = Driver
            .concat([cached, downloaded])
        
        let activeSubscription = hasActiveSubscription()
        
        return Driver
            .combineLatest(categories, activeSubscription)
            .map { [weak self] categories, activeSubscription -> [WCCollectionSection] in
                guard let this = self else {
                    return []
                }
                
                return this.map(categories: categories, activeSubscription: activeSubscription)
            }
    }
}

// MARK: Private
private extension WallpapersCategoriesViewModel {
    func map(categories: WallpaperCategories, activeSubscription: Bool) -> [WCCollectionSection] {
        var sections = [WCCollectionSection]()
        
        if !categories.newArrivals.isEmpty {
            let newArrivalsElements = categories.newArrivals
                .map { WCCollectionElement(category: $0,
                                           activeSubscription: activeSubscription) }
            let newArrivalsSectionModel = WCCollectionSection
                .Section(title: "WallpapersCategories.NewArrivals".localized,
                         elements: newArrivalsElements)
            let newArrivalsSection = WCCollectionSection.newArrivals(newArrivalsSectionModel)
            sections.append(newArrivalsSection)
        }
        
        let categoriesElements = categories.categories
            .map { WCCollectionElement(category: $0,
                                       activeSubscription: activeSubscription) }
        let categoriesSectionModel = WCCollectionSection
            .Section(title: "WallpapersCategories.Title".localized,
                     elements: categoriesElements)
        let categoriesSection = WCCollectionSection.categories(categoriesSectionModel)
        sections.append(categoriesSection)
        
        return sections
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
