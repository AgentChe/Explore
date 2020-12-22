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
    private let wallpapersManager: WallpapersManager = WallpapersManagerCore()
    
    func sections() -> Driver<[WCCollectionSection]> {
        let cached = wallpapersManager
            .rxGetWallpaperCategories(forceUpdate: false)
            .map(map(categories:))
            .asDriver(onErrorJustReturn: [])
        
        let downloaded = wallpapersManager
            .rxGetWallpaperCategories(forceUpdate: true)
            .map(map(categories:))
            .asDriver(onErrorJustReturn: [])
        
        return Driver
            .concat([cached, downloaded])
    }
}

// MARK: Private
private extension WallpapersCategoriesViewModel {
    func map(categories: WallpaperCategories) -> [WCCollectionSection] {
        var sections = [WCCollectionSection]()
        
        if !categories.newArrivals.isEmpty {
            let newArrivalsElements = categories.newArrivals.map(map(category:))
            let newArrivalsSectionModel = WCCollectionSection.Section(title: "WallpapersCategories.NewArrivals".localized, elements: newArrivalsElements)
            let newArrivalsSection = WCCollectionSection.newArrivals(newArrivalsSectionModel)
            sections.append(newArrivalsSection)
        }
        
        let categoriesElements = categories.categories.map(map(category:))
        let categoriesSectionModel = WCCollectionSection.Section(title: "WallpapersCategories.Title".localized, elements: categoriesElements)
        let categoriesSection = WCCollectionSection.categories(categoriesSectionModel)
        sections.append(categoriesSection)
        
        return sections
    }
    
    func map(category: WallpaperCategory) -> WCCollectionElement {
        WCCollectionElement(categoryId: category.id,
                            name: category.name,
                            imageUrl: category.imageUrl,
                            wallpapersCount: category.wallpapersCount)
    }
}
