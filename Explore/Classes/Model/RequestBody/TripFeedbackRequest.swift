//
//  TripFeedbackRequest.swift
//  Explore
//
//  Created by Andrey Chernyshev on 26.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import Alamofire

struct TripFeedbackRequest: APIRequestBody {
    private let userToken: String
    private let tripId: Int
    private let feedback: String
    
    init(userToken: String, tripId: Int, feedback: String) {
        self.userToken = userToken
        self.tripId = tripId
        self.feedback = feedback
    }
    
    var url: String {
        GlobalDefinitions.domain + "/api/users/edit_location"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "id": tripId,
            "notes": feedback
        ]
    }
}
