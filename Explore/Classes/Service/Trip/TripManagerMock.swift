//
//  TripManagerMock.swift
//  Explore
//
//  Created by Andrey Chernyshev on 29.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift
import RxCocoa

final class TripManagerMock: TripManager {
    private struct Constants {
        static let tripCacheKey = "trip_manager_mock_trip_cache_key"
        static let tripInProgressKey = "trip_manager_mock_trip_in_progress_key"
    }
    
    private var delegates = [Weak<TripManagerDelegate>]()
    
    fileprivate let changedProgressStateTrigger = PublishRelay<Bool>()
    fileprivate let tripWasRemovedTrigger = PublishRelay<Void>()
}

// MARK: API - Trip

extension TripManagerMock {
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

extension TripManagerMock {
    func rxGetTrip() -> Single<Trip?> {
        .deferred { [weak self] in .just(self?.getTrip()) }
    }
    
    func rxRemoveTrip() -> Single<Void> {
        .deferred { [weak self] in .just(self?.removeTrip() ?? Void()) }
    }
    
    func rxHasTrip() -> Single<Bool> {
        .deferred { [weak self] in .just(self?.hasTrip() ?? false) }
    }
    
    func rxAddTripToProgress() -> Single<Bool> {
        .deferred { [weak self] in .just(self?.addTripToProgress() ?? false) }
    }
    
    func rxRemoveTripFromProgress() -> Single<Void> {
        .deferred { [weak self] in .just(self?.removeTripFromProgress() ?? Void()) }
    }
    
    func rxIsTripInProgress() -> Single<Bool> {
        .deferred { [weak self] in .just(self?.isTripInProgress() ?? false) }
    }
    
    func rxCreateTrip(with coordinate: Coordinate) -> Single<Bool> {
        Single<Bool>
            .create { [weak self] event in
                guard let this = self else {
                    return Disposables.create()
                }
                
                DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 1) {
                    DispatchQueue.main.async {
                        let trip = Trip(id: Int.random(in: 1...100000), toCoordinate: coordinate)
                        Bool.random() ? event(.success(this.storeTrip(trip))) : event(.error(PaymentError.needPayment))
                    }
                }
            
                return Disposables.create()
            }
    }
}

// MARK: API(Rx) - Feedback

extension TripManagerMock {
    func rxCreateFeedback(tripId: Int, text: String) -> Single<Bool> {
        Single<Bool>
            .create { event in
                DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 1) {
                    DispatchQueue.main.async {
                        event(.success(true))
                    }
                }
        
                return Disposables.create()
            }
    }
}

// MARK: Trigger(Rx)

extension TripManagerMock {
    var rxChangedProgressState: Signal<Bool> {
        changedProgressStateTrigger.asSignal()
    }
    
    var rxTripWasRemovedTrigger: Signal<Void> {
        tripWasRemovedTrigger.asSignal()
    }
}

// MARK: Observer

extension TripManagerMock {
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

private extension TripManagerMock {
    @discardableResult
    func storeTrip(_ trip: Trip) -> Bool {
        guard let data = try? Trip.encode(object: trip) else {
            return false
        }
        
        UserDefaults.standard.set(data, forKey: Constants.tripCacheKey)
        
        return true
    }
}
