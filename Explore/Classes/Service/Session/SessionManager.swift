//
//  SessionManager.swift
//  Explore
//
//  Created by Andrey Chernyshev on 26.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift

final class SessionManager {
    static let shared = SessionManager()
    
    private struct Constants {
        static let sessionKey = "session_manager_session_key"
    }
    
    private init() {}
}

// MARK: API

extension SessionManager {
    @discardableResult
    func store(session: Session) -> Bool {
        guard let data = try? Session.encode(object: session) else {
            return false
        }
        
        UserDefaults.standard.set(data, forKey: Constants.sessionKey)
        
        return true
    }
    
    func getSession() -> Session? {
        guard let data = UserDefaults.standard.data(forKey: Constants.sessionKey) else {
            return nil 
        }
        
        return try? Session.parse(from: data)
    }
}

// MARK: API - Rx

extension Reactive where Base: SessionManager {
    func store(session: Session) -> Single<Bool> {
        .deferred { [weak base] in .just(base?.store(session: session) ?? false) }
    }
    
    func getSession() -> Single<Session?> {
        .deferred { [weak base] in .just(base?.getSession()) }
    }
}

// MARK: Rx

extension SessionManager: ReactiveCompatible {}
