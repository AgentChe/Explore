//
//  GetWallpapersRequest.swift
//  Explore
//
//  Created by Andrey Chernyshev on 15.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import Alamofire

struct GetWallpapersRequest: APIRequestBody {
    private let userToken: String
    private let hash: String?
    
    init(userToken: String, hash: String? = nil) {
        self.userToken = userToken
        self.hash = hash
    }
    
    var url: String {
        GlobalDefinitions.domain + "/api/wallpapers/list"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        var params = [
            "_api_key": GlobalDefinitions.apiKey
        ]
        
        if let hash = self.hash {
            params["wallpapers_hash"] = hash
        }
        
        return params
    }
}
