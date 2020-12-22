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
    
    func section(for categoryId: Int) -> Driver<WallpaperCollectionSection> {
        wallpapersManager
            .rxGetWallpaperCategory(categoryId: categoryId, forceUpdate: false)
            .compactMap(map(category:))
            .asDriver(onErrorDriveWith: .empty())
    }
}

// MARK: Private
private extension WallpapersViewModel {
    func map(category: WallpaperCategory?) -> WallpaperCollectionSection? {
        guard let category = category else {
            return nil
        }
        
        return WallpaperCollectionSection(title: category.name,
                                          elements: category.wallpapers)
    }
}
