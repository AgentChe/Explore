//
//  SetIDFARequest.swift
//  Explore
//
//  Created by Andrey Chernyshev on 14.10.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import Alamofire

struct SetIDFARequest: APIRequestBody {
    private let userToken: String
    private let idfa: String
    
    init(userToken: String, idfa: String) {
        self.userToken = userToken
        self.idfa = idfa
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var url: String {
        GlobalDefinitions.domain + "/api/users/set"
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "idfa": idfa,
            "_user_token": userToken
        ]
    }
}