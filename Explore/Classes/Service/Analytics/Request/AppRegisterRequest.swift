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
    private let attributions: [String: Any]?
    
    init(idfa: String, appKey: String, version: String, attributions: [String: Any]?) {
        self.idfa = idfa
        self.appKey = appKey
        self.version = version
        self.attributions = attributions
    }
    
    var url: String {
        GlobalDefinitions.domain + "/api/app_installs/register"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        var result = attributions ?? [:]
        result["_api_key"] = GlobalDefinitions.apiKey
        result["idfa"] = idfa
        result["random_string"] = appKey
        result["version"] = version
        return result
    }
}
