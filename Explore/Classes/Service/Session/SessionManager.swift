//
//  SessionManager.swift
//  Explore
//
//  Created by Andrey Chernyshev on 26.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift
import RxCocoa

final class SessionManager {
    static let shared = SessionManager()
    
    private struct Constants {
        static let sessionKey = "session_manager_session_key"
    }
    
    private var delegates = [Weak<SessionManagerDelegate>]()
    
    fileprivate let didStoredSessionTrigger = PublishRelay<Session>()
    
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
        
        didStoredSessionTrigger.accept(session)
        
        delegates.forEach { $0.weak?.sessionManagerDidStored(session: session) }
        
        return true
    }
    
    // TODO
    func getSession() -> Session? {
//        guard let data = UserDefaults.standard.data(forKey: Constants.sessionKey) else {
//            return nil
//        }
//
//        return try? Session.parse(from: data)
        Session(userToken: "123", activeSubscription: true, userId: 1)
    }
}

// MARK: API(Rx)
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

// MARK: Trigger(Rx)
extension SessionManager {
    var didStoredSession: Signal<Session> {
        didStoredSessionTrigger.asSignal()
    }
}

// MARK: Observer
extension SessionManager {
    func add(observer: SessionManagerDelegate) {
        let weakly = observer as AnyObject
        delegates.append(Weak<SessionManagerDelegate>(weakly))
        delegates = delegates.filter { $0.weak != nil }
    }
    
    func remove(observer: SessionManagerDelegate) {
        if let index = delegates.firstIndex(where: { $0.weak === observer }) {
            delegates.remove(at: index)
        }
    }
}
