//
//  AmplitudeManager.swift
//  Explore
//
//  Created by Andrey Chernyshev on 16.10.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import Amplitude_iOS
import iAd
import RxSwift

final class AmplitudeManager {
    static let shared = AmplitudeManager()
    
    struct Constants {
        static let initialeUserAttributionsKey = "amplitude_manager_initiale_user_attributions_key"
    }
    
    private init() {}
}

// MARK: API
extension AmplitudeManager {
    func configure() {
        Amplitude.instance()?.initializeApiKey(GlobalDefinitions.amplitudeAPIKey)
        
        SessionManager.shared.add(observer: self)
        
        initialeUserAttributions()
    }
    
    func logEvent(name: String, parameters: [String: Any] = [:]) {
        var dictionary = parameters
        dictionary["app"] = GlobalDefinitions.applicationTag
        
        Amplitude.instance()?.logEvent(name, withEventProperties: dictionary)
    }
}

// MARK: SessionManagerDelegate
extension AmplitudeManager: SessionManagerDelegate {
    func sessionManagerDidStored(session: Session) {
        if let userId = session.userId {
            Amplitude.instance()?.setUserId(String(userId))
        }
    }
}

// MARK: Private
private extension AmplitudeManager {
    func initialeUserAttributions() {
        guard !UserDefaults.standard.bool(forKey: Constants.initialeUserAttributionsKey) else {
            return
        }
        
        Amplitude.instance()?.setUserProperties([
            "app": GlobalDefinitions.applicationTag
        ])
        
        logEvent(name: "First Launch")
        
        UserDefaults.standard.set(true, forKey: Constants.initialeUserAttributionsKey)
    }
}
