//
//  TripManager.swift
//  Explore
//
//  Created by Andrey Chernyshev on 26.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift
import RxCocoa

final class TripManager {
    private struct Constants {
        static let tripCacheKey = "trip_manager_trip_cache_key"
        static let tripInProgressKey = "trip_manager_trip_in_progress_key"
    }
    
    private var delegates = [Weak<TripManagerDelegate>]()
    
    fileprivate let changedProgressStateTrigger = PublishRelay<Bool>()
    fileprivate let tripWasRemovedTrigger = PublishRelay<Void>()
}

// MARK: API - Trip

extension TripManager {
    func getTrip() -> Trip? {
        guard let data = UserDefaults.standard.data(forKey: Constants.tripCacheKey) else {
            return nil
        }
        
        return try? Trip.parse(from: data)
    }
    
    func removeTrip() {
        UserDefaults.standard.removeObject(forKey: Constants.tripCacheKey)
        UserDefaults.standard.removeObject(forKey: Constants.tripInProgressKey)
        
        delegates.forEach { $0.weak?.tripManagerTripWasRemoved() }
        
        tripWasRemovedTrigger.accept(Void())
    }
    
    func hasTrip() -> Bool {
        getTrip() != nil
    }
    
    @discardableResult
    func addTripToProgress() -> Bool {
        guard hasTrip() else {
            return false
        }
        
        UserDefaults.standard.set(true, forKey: Constants.tripInProgressKey)
        
        delegates.forEach { $0.weak?.tripManagerChanged(progressState: true) }
        
        changedProgressStateTrigger.accept(true)
        
        return true
    }
    
    func removeTripFromProgress() {
        UserDefaults.standard.set(false, forKey: Constants.tripInProgressKey)
        
        delegates.forEach { $0.weak?.tripManagerChanged(progressState: false) }
        
        changedProgressStateTrigger.accept(false)
    }
    
    func isTripInProgress() -> Bool {
        UserDefaults.standard.bool(forKey: Constants.tripInProgressKey)
    }
}

// MARK: API(Rx) - Trip

extension Reactive where Base: TripManager {
    func getTrip() -> Single<Trip?> {
        .deferred { [weak base] in .just(base?.getTrip()) }
    }
    
    func removeTrip() -> Single<Void> {
        .deferred { [weak base] in .just(base?.removeTrip() ?? Void()) }
    }
    
    func hasTrip() -> Single<Bool> {
        .deferred { [weak base] in .just(base?.hasTrip() ?? false) }
    }
    
    func addTripToProgress() -> Single<Bool> {
        .deferred { [weak base] in .just(base?.addTripToProgress() ?? false) }
    }
    
    func removeTripFromProgress() -> Single<Void> {
        .deferred { [weak base] in .just(base?.removeTripFromProgress() ?? Void()) }
    }
    
    func isTripInProgress() -> Single<Bool> {
        .deferred { [weak base] in .just(base?.isTripInProgress() ?? false) }
    }
    
    // TODO: Check when API will done
    func createTrip(with coordinate: Coordinate) -> Single<Bool> {
        guard let userToken = SessionManager.shared.getSession()?.userToken else {
            return .deferred { .just(false) }
        }
        
        return RestAPITransport()
            .callServerApi(requestBody: CreateTripRequest(userToken: userToken,
                                                          coordinate: coordinate))
            .map { ErrorChecker.hasError(in: $0) }
            .flatMap { [weak base] _ in
                .deferred { .just(base?.storeTrip(with: coordinate) ?? false) }
            }
    }
}

// MARK: API(Rx) - Feedback

extension Reactive where Base: TripManager {
    // TODO: Check when API will done
    func createFeedback(text: String) -> Single<Bool> {
        guard let userToken = SessionManager.shared.getSession()?.userToken else {
            return .deferred { .just(false) }
        }
        
        return RestAPITransport()
            .callServerApi(requestBody: TripFeedbackRequest(userToken: userToken,
                                                            feedback: text))
            .map { ErrorChecker.hasError(in: $0) }
    }
}

// MARK: Trigger(Rx)

extension Reactive where Base: TripManager {
    var changedProgressState: Signal<Bool> {
        base.changedProgressStateTrigger.asSignal()
    }
    
    var tripWasRemovedTrigger: Signal<Void> {
        base.tripWasRemovedTrigger.asSignal()
    }
}

// MARK: Rx

extension TripManager: ReactiveCompatible {}

// MARK: Observer

extension TripManager {
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

// MARK: Private

private extension TripManager {
    @discardableResult
    func storeTrip(with toCoordinate: Coordinate) -> Bool {
        let trip = Trip(toCoordinate: toCoordinate)
        
        guard let data = try? Trip.encode(object: trip) else {
            return false
        }
        
        UserDefaults.standard.set(data, forKey: Constants.tripCacheKey)
        
        return true
    }
}
