//
//  GetPlaceResponseMapper.swift
//  Explore
//
//  Created by Andrey Chernyshev on 06.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

final class GetPlaceResponseMapper {
    static func from(response: Any, with coordinate: Coordinate) -> Place? {
        guard
            let json = response as? [String: Any],
            let about = json["data"] as? String
        else {
            return nil
        }
        
        return Place(about: about, coordinate: coordinate)
    }
}
