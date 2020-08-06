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
    // radius - metr
    static func findCoordinate(from current: Coordinate, on radius: Double) -> Single<Coordinate> {
        let distance = Double.random(in: 10...radius)
        let radius_radians = distance / 6372797.6
        
        let direction = Double.random(in: 0...360)
        let direction_radians = direction * .pi / 180.0
        
        let latitude1 = current.latitude * .pi / 180
        let longitude1 = current.longitude * .pi / 180

        let latitude2 = asin(sin(latitude1) * cos(radius_radians) + cos(latitude1) * sin(radius_radians) * cos(direction_radians))
        let longitude2 = longitude1 + atan2(sin(direction_radians) * sin(radius_radians) * cos(latitude1), cos(radius_radians) - sin(latitude1) * sin(latitude2))
        
        let latitude3 = latitude2 * 180 / .pi
        let longitude3 = longitude2 * 180 / .pi
        
        return .deferred { .just(Coordinate(latitude: latitude3, longitude: longitude3)) }
    }
}
