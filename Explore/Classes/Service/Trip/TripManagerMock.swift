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
        
        TripMediator.shared.notifyAboutTripWasRemoved()
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
        
        TripMediator.shared.notifyAboutChangedProgress(state: true)
        
        return true
    }
    
    func removeTripFromProgress() {
        UserDefaults.standard.set(false, forKey: Constants.tripInProgressKey)
        
        TripMediator.shared.notifyAboutChangedProgress(state: false)
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
//                        Bool.random() ? event(.success(this.storeTrip(trip))) : event(.error(PaymentError.needPayment))
                        event(.success(this.storeTrip(trip)))
                    }
                }
            
                return Disposables.create()
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
