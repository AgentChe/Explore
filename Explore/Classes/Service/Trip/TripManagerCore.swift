//
//  TripManager.swift
//  Explore
//
//  Created by Andrey Chernyshev on 26.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift
import RxCocoa

final class TripManagerCore: TripManager {
    private struct Constants {
        static let tripCacheKey = "trip_manager_core_trip_cache_key"
        static let tripInProgressKey = "trip_manager_core_trip_in_progress_key"
    }
}

// MARK: API - Trip
extension TripManagerCore {
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
extension TripManagerCore {
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
        guard let userToken = SessionManager.shared.getSession()?.userToken else {
            return .deferred { .error(SignError.tokenNotFound) }
        }
        
        return SDKStorage.shared
            .restApiTransport
            .callServerApi(requestBody: CreateTripRequest(userToken: userToken,
                                                          coordinate: coordinate))
            .map { try ErrorChecker.throwErrorIfHas(from: $0) } 
            .flatMap { [weak self] response in
                guard let this = self, let trip = CreateTripResponseMapper.map(response: response, toCoordinate: coordinate) else {
                    return .just(false)
                }
                
                return .just(this.storeTrip(trip))
            }
    }
}

// MARK: Private
private extension TripManagerCore {
    @discardableResult
    func storeTrip(_ trip: Trip) -> Bool {
        guard let data = try? Trip.encode(object: trip) else {
            return false
        }
        
        UserDefaults.standard.set(data, forKey: Constants.tripCacheKey)
        
        return true
    }
}
