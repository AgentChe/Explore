//
//  WCCollectionElement.swift
//  Explore
//
//  Created by Andrey Chernyshev on 21.12.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

struct WCCollectionElement {
    let categoryId: Int
    let name: String
    let imageUrl: String
    let wallpapersCount: Int
    let isLock: Bool
    
    init(category: WallpaperCategory, activeSubscription: Bool) {
        categoryId = category.id
        name = category.name
        imageUrl = category.imageUrl
        wallpapersCount = category.wallpapersCount
        isLock = !activeSubscription && category.paid
    }
}
