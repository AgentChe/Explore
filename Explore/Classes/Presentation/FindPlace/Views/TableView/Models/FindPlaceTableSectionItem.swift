//
//  FindPlaceTableSectionItem.swift
//  Explore
//
//  Created by Andrey Chernyshev on 31.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

enum FindPlaceTableSectionItem {
    case requireGeoPermission
    case deniedGeoPermission
    case searchedCoordinate(Coordinate)
    case whatYourSearchIntent(FPWhatYourSearchIntentCell.Tag?)
    case whatLikeGet(FPWhatLikeGetCell.Tag?)
    case complete
    case whatItis(String)
    case notification(String)
    case radius(FPTableRadiusBundle)
}
