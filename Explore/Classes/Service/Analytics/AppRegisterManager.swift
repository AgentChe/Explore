//
//  AppRegisterManager.swift
//  Explore
//
//  Created by Andrey Chernyshev on 19.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class AppRegisterManager {
    static let shared = AppRegisterManager()
    
    struct Constants {
        static let appWasRegisteredKey = "app_was_registered_key"
    }
    
    private init() {}
}

// MARK: API

extension AppRegisterManager {
    func configure() {
        appRegister()
    }
}

// MARK: Private

private extension AppRegisterManager {
    func appRegister() {
        guard !UserDefaults.standard.bool(forKey: Constants.appWasRegisteredKey) else {
            return
        }
        
        let request = AppRegisterRequest(idfa: IDFAService.shared.getIDFA(),
                                        appKey: IDFAService.shared.getAppKey(),
                                        version: UIDevice.appVersion ?? "1")
            
        _ = RestAPITransport()
            .callServerApi(requestBody: request)
            .subscribe(onSuccess: { _ in
                UserDefaults.standard.set(true, forKey: Constants.appWasRegisteredKey)
            })
    }
}
