//
//  FindPlaceTableSection.swift
//  Explore
//
//  Created by Andrey Chernyshev on 31.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

struct FindPlaceTableSection {
    let identifier: String
    let items: [FindPlaceTableSectionItem]
}

// MARK: Identifiers

extension FindPlaceTableSection {
    struct Identifiers {
        static let requireGeoPermission = "requireGeoPermission"
        static let deniedGeoPermission = "deniedGeoPermission"
        static let notification = "notification"
        static let searchedCoordinate = "searchedCoordinate"
        static let whatLikeGet = "whatLikeGet"
        static let complete = "complete"
        static let whatItis = "whatItis"
    }
}
