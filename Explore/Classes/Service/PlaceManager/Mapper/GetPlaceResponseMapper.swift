//
//  GetPlaceResponseMapper.swift
//  Explore
//
//  Created by Andrey Chernyshev on 06.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

final class GetPlaceResponseMapper {
    // TODO
    static func from(response: Any, with coordinate: Coordinate) -> Place? {
        Place(about: "no need to normalize a heading in degrees to be within -179.999999° to 180.00000°",
              coordinate: coordinate)
    }
}
