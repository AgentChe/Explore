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
    // MARK: API(Rx)
    func rxGetWallpaperCategories(forceUpdate: Bool) -> Single<WallpaperCategories>
    func rxGetWallpapers(categoryId: Int, forceUpdate: Bool) -> Single<[Wallpaper]>
    func rxGetWallpaperCategory(categoryId: Int, forceUpdate: Bool) -> Single<WallpaperCategory?>
}
