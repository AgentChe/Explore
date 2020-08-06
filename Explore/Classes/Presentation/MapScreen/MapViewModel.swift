//
//  MapViewModel.swift
//  Explore
//
//  Created by Andrey Chernyshev on 05.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift
import RxCocoa

final class MapViewModel {
    let activityIndicator = RxActivityIndicator()
    
    let findPlace = PublishRelay<Coordinate>()
    
    private let geoLocationManager = GeoLocationManager(mode: .whenInUseAuthorization)
    
    func getCurrentCooordinate() -> Driver<Coordinate?> {
        Single<Coordinate?>
            .create { [geoLocationManager] event in
                geoLocationManager.requestAuthorization { status in
                    switch status {
                    case .authorization:
                        geoLocationManager.justDetermineCurrentLocation { coordinate in
                            event(.success(coordinate))
                        }
                    case .denied:
                        event(.success(nil))
                    case .notDetermined:
                        break
                    }
                }
            
                return Disposables.create()
            }
            .trackActivity(activityIndicator)
            .asDriver(onErrorJustReturn: nil)
    }
    
    func place() -> Driver<Place?> {
        findPlace
            .flatMapLatest { [activityIndicator] currentCoordinate -> Observable<Place?> in
                GeoLocationUtils
                    .findCoordinate(from: currentCoordinate, on: 20)
                    .flatMap { coordinate in
                        PlaceService
                            .getPlace(for: coordinate)
                            .catchErrorJustReturn(nil)
                    }
                    .trackActivity(activityIndicator)
            }
            .asDriver(onErrorJustReturn: nil)
    }
}
