//
//  GetPlaceRequest.swift
//  Explore
//
//  Created by Andrey Chernyshev on 06.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import Alamofire

struct GetPlaceRequest: APIRequestBody {
    private let coordinate: Coordinate
    
    init(coordinate: Coordinate) {
        self.coordinate = coordinate
    }
}
