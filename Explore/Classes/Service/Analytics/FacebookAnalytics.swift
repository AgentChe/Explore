//
//  FacebookAnalytics.swift
//  Explore
//
//  Created by Andrey Chernyshev on 09.10.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import FBSDKCoreKit
import RxSwift
import RxCocoa

final class FacebookAnalytics {
    static let shared = FacebookAnalytics()
    
    private init() {}
    
    func configure() {
        AppEvents.activateApp()
        
        setInitialProperties()
        syncedUserPropertiesWithUserId()
    }
    
    func set(userId: String) {
        AppEvents.userID = userId
    }
    
    func set(userAttributes: [String: Any]) {
        AppEvents.updateUserProperties(userAttributes, handler: nil)
    }
    
    func logPurchase(amount: Double, currency: String) {
        AppEvents.logPurchase(amount, currency: currency)
    }
    
    func fetchDeferredLink(handler: @escaping ((URL?) -> Void)) {
        AppLinkUtility.fetchDeferredAppLink { url, _ in
            handler(url)
        }
    }
}

// MARK: Private

private extension FacebookAnalytics {
    func setInitialProperties() {
        guard !UserDefaults.standard.bool(forKey: "facebook_initial_properties_is_set") else {
            return
        }
        
        set(userAttributes: ["city": "none"])
        
        UserDefaults.standard.set(true, forKey: "facebook_initial_properties_is_set")
    }
    
    func syncedUserPropertiesWithUserId() {
        guard !UserDefaults.standard.bool(forKey: "facebook_initial_properties_is_synced") else {
            return
        }
        
        _ = Signal
            .merge(
                SessionManager.shared.didStoredSession,
                
                Signal.deferred {
                    Signal.just(SessionManager.shared.getSession()).compactMap { $0 }
                }
            )
            .emit(onNext: { session in
                guard let userId = session.userId else {
                    return
                }
                
                self.set(userId: "\(userId)")
                
                UserDefaults.standard.set(true, forKey: "facebook_initial_properties_is_synced")
            })
    }
}
