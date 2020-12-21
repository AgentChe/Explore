//
//  GetWallpapersRequest.swift
//  Explore
//
//  Created by Andrey Chernyshev on 15.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import Alamofire

struct GetWallpapersRequest: APIRequestBody {
    private let userToken: String?
    
    init(userToken: String?) {
        self.userToken = userToken
    }
    
    var url: String {
        GlobalDefinitions.domain + "/api/wallpapers_new/list"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        var params = [
            "_api_key": GlobalDefinitions.apiKey,
            "anonymous_id": SDKStorage.shared.applicationAnonymousID
        ]
        
        if let userToken = self.userToken {
            params["_user_token"] = userToken
        }
        
        return params
    }
}
