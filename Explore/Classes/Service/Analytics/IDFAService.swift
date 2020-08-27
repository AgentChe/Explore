//
//  IDFAService.swift
//  Explore
//
//  Created by Andrey Chernyshev on 26.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift
import AdSupport

final class IDFAService {
    static let shared = IDFAService()
    
    private struct Constants {
        static let appKey = "idfa_service_app_key"
    }
    
    private init() {}
}

// MARK: App key

extension IDFAService {
    func getAppKey() -> String {
        if let randomKey = UserDefaults.standard.string(forKey: Constants.appKey) {
            return randomKey
        } else {
            let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            let randomKey = String((0..<128).map { _ in letters.randomElement()! })
            UserDefaults.standard.set(randomKey, forKey: Constants.appKey)
            return randomKey
        }
    }
}
