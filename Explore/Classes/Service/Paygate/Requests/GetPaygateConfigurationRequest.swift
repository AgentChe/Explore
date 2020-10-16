//
//  GetPaygateConfigurationRequest.swift
//  Explore
//
//  Created by Andrey Chernyshev on 15.10.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import Alamofire

struct GetPaygateConfigurationRequest: APIRequestBody {
    var method: HTTPMethod {
        .post
    }
    
    var url: String {
        GlobalDefinitions.domain + "/api/configuration"
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey
        ]
    }
}
