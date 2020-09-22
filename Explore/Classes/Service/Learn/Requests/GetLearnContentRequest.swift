//
//  GetLearnContentRequest.swift
//  Explore
//
//  Created by Andrey Chernyshev on 20.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import Alamofire

struct GetLearnContentRequest: APIRequestBody {
    private let articleId: Int
    
    init(articleId: Int) {
        self.articleId = articleId
    }
    
    var url: String {
        GlobalDefinitions.domain + "/api/learn/get"
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "id": articleId
        ]
    }
    
    var encoding: ParameterEncoding {
        URLEncoding.default
    }
}
