//
//  PurchaseValidateRequest.swift
//  Explore
//
//  Created by Andrey Chernyshev on 26.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import Alamofire

struct PurchaseValidateRequest: APIRequestBody {
    private let userToken: String?
    private let receipt: String
    private let version: String
    
    init(userToken: String?, receipt: String, version: String) {
        self.userToken = userToken
        self.receipt = receipt
        self.version = version
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var url: String {
        GlobalDefinitions.domain + "/api/payments/validate"
    }
    
    var parameters: Parameters? {
        var params = [
            "_api_key": GlobalDefinitions.apiKey,
            "receipt": receipt,
            "version": version
        ]
        
        if let userToken = userToken {
            params["_user_token"] = userToken
        }
        
        return params
    }
}
