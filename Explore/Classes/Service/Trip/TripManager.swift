//
//  TripManager.swift
//  Explore
//
//  Created by Andrey Chernyshev on 29.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift
import RxCocoa

protocol TripManager: class {
    //MARK: API - Trip
    
    func getTrip() -> Trip?
    func removeTrip()
    func hasTrip() -> Bool
    @discardableResult func addTripToProgress() -> Bool
    func removeTripFromProgress()
    func isTripInProgress() -> Bool
    
    // MARK: API(Rx) - Trip
    
    func rxGetTrip() -> Single<Trip?>
    func rxRemoveTrip() -> Single<Void>
    func rxHasTrip() -> Single<Bool>
    func rxAddTripToProgress() -> Single<Bool>
    func rxRemoveTripFromProgress() -> Single<Void>
    func rxIsTripInProgress() -> Single<Bool>
    func rxCreateTrip(with coordinate: Coordinate) -> Single<Bool>
    
    // MARK: API(Rx) - Feedback
    
    func rxCreateFeedback(text: String) -> Single<Bool>
    
    // MARK: Trigger(Rx)
    
    var rxChangedProgressState: Signal<Bool> { get }
    var rxTripWasRemovedTrigger: Signal<Void> { get }
    
    // MARK: Observer
    
    func add(observer: TripManagerDelegate)
    func remove(observer: TripManagerDelegate)
}
