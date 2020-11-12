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
    private let geoLocationManager = GeoLocationManager(mode: .whenInUseAuthorization)
    private let tripManager: TripManager = TripManagerCore()
    
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
        
        let updated = TripMediator.shared
            .rxChangedProgressState
            .asDriver(onErrorJustReturn: false)
        
        return Driver.merge(initial, updated)
    }
    
    func getTrip() -> Trip? {
        tripManager.getTrip()
    }
    
    func addTripToProgress() -> Bool {
        tripManager.addTripToProgress()
    }
}
