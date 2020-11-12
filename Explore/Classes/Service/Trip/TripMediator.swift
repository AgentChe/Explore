//
//  TripMediator.swift
//  Explore
//
//  Created by Andrey Chernyshev on 12.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift
import RxCocoa

final class TripMediator {
    static let shared = TripMediator()
    
    private var delegates = [Weak<TripManagerDelegate>]()
    
    fileprivate let changedProgressStateTrigger = PublishRelay<Bool>()
    fileprivate let tripWasRemovedTrigger = PublishRelay<Void>()
    
    private init() {}
}

// MARK: API
extension TripMediator {
    func notifyAboutChangedProgress(state: Bool) {
        delegates.forEach { $0.weak?.tripManagerChanged(progressState: state) }
        
        changedProgressStateTrigger.accept(state)
    }
    
    func notifyAboutTripWasRemoved() {
        delegates.forEach { $0.weak?.tripManagerTripWasRemoved() }
        
        tripWasRemovedTrigger.accept(Void())
    }
}

// MARK: Trigger(Rx)
extension TripMediator {
    var rxChangedProgressState: Signal<Bool> {
        changedProgressStateTrigger.asSignal()
    }
    
    var rxTripWasRemovedTrigger: Signal<Void> {
        tripWasRemovedTrigger.asSignal()
    }
}

// MARK: Observer
extension TripMediator {
    func add(observer: TripManagerDelegate) {
        let weakly = observer as AnyObject
        delegates.append(Weak<TripManagerDelegate>(weakly))
        delegates = delegates.filter { $0.weak != nil }
    }
    
    func remove(observer: TripManagerDelegate) {
        if let index = delegates.firstIndex(where: { $0.weak === observer }) {
            delegates.remove(at: index)
        }
    }
}
