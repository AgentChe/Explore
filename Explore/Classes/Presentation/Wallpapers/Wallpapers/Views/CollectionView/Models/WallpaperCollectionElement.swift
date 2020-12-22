//
//  WallpaperCollectionElement.swift
//  Explore
//
//  Created by Andrey Chernyshev on 22.12.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

struct WallpaperCollectionElement {
    let wallpaper: Wallpaper
    let hasActiveSubscription: Bool
    
    init(wallpaper: Wallpaper, hasActiveSubscription: Bool) {
        self.wallpaper = wallpaper
        self.hasActiveSubscription = hasActiveSubscription
    }
}

// MARK: API
extension WallpaperCollectionElement {
    var isLock: Bool {
        !hasActiveSubscription && wallpaper.paid
    }
}
