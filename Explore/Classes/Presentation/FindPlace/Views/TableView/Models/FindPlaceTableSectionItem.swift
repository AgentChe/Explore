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
    case whatLikeGet(FPWhatLikeGetCell.Tag?)
    case complete
    case whatItis
    case notification(String)
}
