//
//  PaygateConfiguration.swift
//  Explore
//
//  Created by Andrey Chernyshev on 15.10.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

struct PaygateConfiguration: Codable {
    let activeSubscription: Bool
    let onboardingPaygate: Bool
    let generateSpotPaygate: Bool
    let navigateSpotPaygate: Bool
    let learnPaygate: Bool
    let seePaygate: Bool
}
