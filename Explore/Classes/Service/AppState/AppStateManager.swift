//
//  AppStateManager.swift
//  Explore
//
//  Created by Andrey Chernyshev on 30.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift
import RxCocoa

final class AppStateManager {
    static let shared = AppStateManager()
    
    private var delegates = [Weak<AppStateManagerDelegate>]()
    
    private let willResignApplicationTrigger = PublishRelay<Void>()
    private let didBecomeApplicationTrigger = PublishRelay<Void>()
    
    private init() {}
}

// MARK: API

extension AppStateManager {
    func applicationDidBecome () {
        didBecomeApplicationTrigger.accept(Void())
        
        delegates.forEach {
            $0.weak?.appStateManagerDidBecomeApplication()
        }
    }
    
    func applicationWillResign() {
        willResignApplicationTrigger.accept(Void())
        
        delegates.forEach {
            $0.weak?.appStateManagerWillResignApplication()
        }
    }
}

// MARK: Trigger (Rx)

extension AppStateManager {
    var rxWillResignApplication: Signal<Void> {
        willResignApplicationTrigger.asSignal()
    }
    
    var rxDidBecomeApplication: Signal<Void> {
        didBecomeApplicationTrigger.asSignal()
    }
}

// MARK: Observer

extension AppStateManager {
    func add(observer: AppStateManagerDelegate) {
        let weakly = observer as AnyObject
        delegates.append(Weak<AppStateManagerDelegate>(weakly))
        delegates = delegates.filter { $0.weak != nil }
    }
    
    func remove(observer: AppStateManagerDelegate) {
        if let index = delegates.firstIndex(where: { $0.weak === observer }) {
            delegates.remove(at: index)
        }
    }
}
