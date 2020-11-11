//
//  GetJournalArticleDetailsRequest.swift
//  Explore
//
//  Created by Andrey Chernyshev on 06.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import Alamofire

struct GetJournalArticleDetailsRequest: APIRequestBody {
    private let userToken: String
    private let id: Int
    
    init(userToken: String, id: Int) {
        self.userToken = userToken
        self.id = id
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var url: String {
        GlobalDefinitions.domain + "/api/journal/get"
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "id": id
        ]
    }
    
    var encoding: ParameterEncoding {
        URLEncoding.queryString
    }
}
