//
//  GetWallpapersResponseMapper.swift
//  Explore
//
//  Created by Andrey Chernyshev on 21.12.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

final class GetWallpapersResponseMapper {
    static func map(from response: Any) -> WallpaperCategories {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let wallpapersJSON = data["wallpapers"] as? [String: Any]
        else {
            return WallpaperCategories(categories: [], newArrivals: [])
        }
        
        guard
            let content = wallpapersJSON["content"] as? [[String: Any]],
            let contentData = try? JSONSerialization.data(withJSONObject: content),
            let categories = try? JSONDecoder().decode([WallpaperCategory].self, from: contentData)
        else {
            return WallpaperCategories(categories: [], newArrivals: [])
        }
        
        guard let featured = wallpapersJSON["featured"] as? [String: Int] else {
            return WallpaperCategories(categories: categories, newArrivals: [])
        }
        
        var newArrivals = [WallpaperCategory]()
        
        featured.forEach { categoryId, wallpapersCount in
            guard
                let id = Int(categoryId),
                let category = categories.first(where: { $0.id == id })
            else {
                return
            }
            
            let newArrival = GetWallpapersResponseMapper.build(from: category, wallpapersCount: wallpapersCount)
            
            newArrivals.append(newArrival)
        }
        
        return WallpaperCategories(categories: categories, newArrivals: newArrivals)
    }
}

// MARK: Private
private extension GetWallpapersResponseMapper {
    static func build(from category: WallpaperCategory, wallpapersCount: Int) -> WallpaperCategory {
        return WallpaperCategory(id: category.id,
                                 name: category.name,
                                 imageUrl: category.imageUrl,
                                 paid: category.paid,
                                 wallpapersCount: wallpapersCount,
                                 wallpapers: category.wallpapers)
    }
}
