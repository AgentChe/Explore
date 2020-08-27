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
    private let feedback: String
    
    init(userToken: String, feedback: String) {
        self.userToken = userToken
        self.feedback = feedback
    }
}
