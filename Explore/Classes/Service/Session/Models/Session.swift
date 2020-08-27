//
//  Session.swift
//  Explore
//
//  Created by Andrey Chernyshev on 26.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

struct Session {
    let userToken: String?
    let activeSubscription: Bool
    let userId: Int?
}

// MARK: Make

extension Session: Model {
    private enum Keys: String, CodingKey {
        case data = "_data"
        
        case userToken = "user_token"
        case activeSubscription = "active_subscription"
        case userId = "user_id"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        let data = try container.nestedContainer(keyedBy: Keys.self, forKey: .data)
        userToken = try data.decode(String?.self, forKey: .userToken)
        activeSubscription = try data.decode(Bool.self, forKey: .activeSubscription)
        userId = try data.decode(Int?.self, forKey: .userId)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        
        var data = container.nestedContainer(keyedBy: Keys.self, forKey: .data)
        try data.encode(userToken, forKey: .userToken)
        try data.encode(activeSubscription, forKey: .activeSubscription)
        try data.encode(userId, forKey: .userId)
    }
}
