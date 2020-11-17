//
//  DeleteJournalArticleRequest.swift
//  Explore
//
//  Created by Andrey Chernyshev on 10.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import Alamofire

struct DeleteJournalArticleRequest: APIRequestBody {
    private let userToken: String
    private let articleId: Int
    
    init(userToken: String, articleId: Int) {
        self.userToken = userToken
        self.articleId = articleId
    }
    
    var url: String {
        GlobalDefinitions.domain + "/api/journal/delete"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "id": articleId,
            "anonymous_id": SDKStorage.shared.applicationAnonymousID
        ]
    }
}
