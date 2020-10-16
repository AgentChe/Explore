//
//  GetPaygateConfigurationResponseMapper.swift
//  Explore
//
//  Created by Andrey Chernyshev on 15.10.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import Foundation

final class GetPaygateConfigurationResponseMapper {
    static func from(response: Any) -> PaygateConfiguration? {
        guard
            let json = response as? [String: Any],
            let data = try? JSONSerialization.data(withJSONObject: json, options: [])
        else {
            return nil
        }
        
        return try? JSONDecoder().decode(GetPaygateConfigurationResponse.self, from: data).configuration
    }
}

private struct GetPaygateConfigurationResponse: Decodable {
    let configuration: PaygateConfiguration
    
    enum Keys: String, CodingKey {
        case data = "_data"
        case onboardingPaygate = "onboarding_paygate"
        case generateSpotPaygate = "generate_spot_paygate"
        case navigateSpotPaygate = "navigate_spot_paygate"
        case learnPaygate = "learn_paygate"
        case seePaygate = "see_paygate"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        let data = try container.nestedContainer(keyedBy: Keys.self, forKey: .data)
        
        let onboardingPaygate = try data.decode(Bool.self, forKey: .onboardingPaygate)
        let generateSpotPaygate = try data.decode(Bool.self, forKey: .generateSpotPaygate)
        let navigateSpotPaygate = try data.decode(Bool.self, forKey: .navigateSpotPaygate)
        let learnPaygate = try data.decode(Bool.self, forKey: .learnPaygate)
        let seePaygate = try data.decode(Bool.self, forKey: .seePaygate)
        
        configuration = PaygateConfiguration(activeSubscription: false,
                                             onboardingPaygate: onboardingPaygate,
                                             generateSpotPaygate: generateSpotPaygate,
                                             navigateSpotPaygate: navigateSpotPaygate,
                                             learnPaygate: learnPaygate,
                                             seePaygate: seePaygate)
    }
}
