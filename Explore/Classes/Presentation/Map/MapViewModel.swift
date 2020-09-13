//
//  MapViewModel.swift
//  Explore
//
//  Created by Andrey Chernyshev on 27.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift
import RxCocoa

final class MapViewModel {
    let sendFeedback = PublishRelay<String>()
    
    let activityIndicator = RxActivityIndicator()
    
    private let geoLocationManager = GeoLocationManager(mode: .whenInUseAuthorization)
    private let tripManager: TripManager = TripManagerMock()
    
    func monitoringOfCoordinate() -> Driver<Coordinate> {
        defer { geoLocationManager.continuoslyKeepLocation() }
        
        return geoLocationManager.rx
            .continuoslyKeepCurrentLocation
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func trip() -> Driver<Trip?> {
        tripManager
            .rxGetTrip()
            .asDriver(onErrorJustReturn: nil)
    }
    
    func tripInProgress() -> Driver<Bool> {
        let initial = tripManager
            .rxIsTripInProgress()
            .asDriver(onErrorJustReturn: false)
        
        let updated = tripManager
            .rxChangedProgressState
            .asDriver(onErrorJustReturn: false)
        
        return Driver.merge(initial, updated)
    }
    
    func feedbackSended() -> Driver<Bool> {
        sendFeedback
            .flatMapLatest { [tripManager, activityIndicator] feedback -> Observable<Bool> in
                guard let tripId = tripManager.getTrip()?.id else {
                    return .just(false)
                }
                
                return tripManager
                    .rxCreateFeedback(tripId: tripId, text: feedback)
                    .trackActivity(activityIndicator)
                    .catchErrorJustReturn(false)
            }
            .asDriver(onErrorJustReturn: false)
    }
    
    func getTrip() -> Trip? {
        tripManager.getTrip()
    }
    
    func addTripToProgress() -> Bool {
        tripManager.addTripToProgress()
    }
    
    func removeTrip() {
        tripManager.removeTripFromProgress()
        tripManager.removeTrip()
    }
}
