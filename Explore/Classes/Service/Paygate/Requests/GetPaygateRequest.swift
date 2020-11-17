//
//  GetPaygateRequest.swift
//  Explore
//
//  Created by Andrey Chernyshev on 26.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import Alamofire

struct GetPaygateRequest: APIRequestBody {
    private let userToken: String?
    private let locale: String?
    private let version: String
    private let appKey: String
    
    init(userToken: String?, locale: String?, version: String, appKey: String) {
        self.userToken = userToken
        self.locale = locale
        self.version = version
        self.appKey = appKey
    }
    
    var url: String {
        GlobalDefinitions.domain + "/api/payments/paygate"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        var params = [
            "_api_key": GlobalDefinitions.apiKey,
            "version": version,
            "random_string": appKey,
            "anonymous_id": SDKStorage.shared.applicationAnonymousID
        ]
        
        if let locale = self.locale {
            params["locale"] = locale
        }
        
        if let userToken = userToken {
            params["_user_token"] = userToken
        }
        
        return params
    }
}
