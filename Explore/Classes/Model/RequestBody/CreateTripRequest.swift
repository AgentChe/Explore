//
//  CreateTripRequest.swift
//  Explore
//
//  Created by Andrey Chernyshev on 26.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import Alamofire

struct CreateTripRequest: APIRequestBody {
    private let userToken: String
    private let coordinate: Coordinate
    
    init(userToken: String, coordinate: Coordinate) {
        self.userToken = userToken
        self.coordinate = coordinate
    }
}
