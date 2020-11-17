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
    
    var url: String {
        GlobalDefinitions.domain + "/api/users/save_location"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "long": coordinate.longitude,
            "lat": coordinate.latitude,
            "anonymous_id": SDKStorage.shared.applicationAnonymousID
        ]
    }
}
