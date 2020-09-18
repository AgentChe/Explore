//
//  AppRegisterRequest.swift
//  Explore
//
//  Created by Andrey Chernyshev on 18.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import Alamofire

struct AppRegisterRequest: APIRequestBody {
    private let idfa: String
    private let appKey: String
    private let version: String
    
    init(idfa: String, appKey: String, version: String) {
        self.idfa = idfa
        self.appKey = appKey
        self.version = version
    }
    
    var url: String {
        GlobalDefinitions.domain + "/api/app_installs/register"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "idfa": idfa,
            "random_string": appKey,
            "version": version
        ]
    }
}
