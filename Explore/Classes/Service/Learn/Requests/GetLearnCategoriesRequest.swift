//
//  GetLearnCategoriesRequest.swift
//  Explore
//
//  Created by Andrey Chernyshev on 20.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import Alamofire

struct GetLearnCategoriesRequest: APIRequestBody {
    var url: String {
        GlobalDefinitions.domain + "/api/learn/list"
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey
        ]
    }
    
    var encoding: ParameterEncoding {
        URLEncoding.default
    }
}
