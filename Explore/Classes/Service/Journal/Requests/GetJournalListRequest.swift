//
//  GetJournalListRequest.swift
//  Explore
//
//  Created by Andrey Chernyshev on 06.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import Alamofire

struct GetJournalListRequest: APIRequestBody {
    private let userToken: String
    
    init(userToken: String) {
        self.userToken = userToken
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var url: String {
        GlobalDefinitions.domain + "/api/journal/list"
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "anonymous_id": SDKStorage.shared.applicationAnonymousID
        ]
    }
}
