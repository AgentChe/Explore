//
//  GeoLocationUtils.swift
//  Explore
//
//  Created by Andrey Chernyshev on 06.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import CoreLocation
import RxSwift

final class GeoLocationUtils {}

// MARK: Find random coordinate

extension GeoLocationUtils {
    // radius - km
    static func findCoordinate(from current: Coordinate, on radius: Int) -> Single<Coordinate> {
        .deferred { .just(Coordinate(latitude: 55.753804, longitude: 37.621645)) }
    }
}
