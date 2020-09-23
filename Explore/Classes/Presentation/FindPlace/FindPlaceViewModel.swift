//
//  FindPlaceViewModel.swift
//  Explore
//
//  Created by Andrey Chernyshev on 27.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift
import RxCocoa

final class FindPlaceViewModel {
    let reset = PublishRelay<Void>()
    let findGeoPermissionStatus = PublishRelay<Void>()
    let requireGeoPermission = PublishRelay<Void>()
    let findCoordinate = PublishRelay<Void>()
    let whatLikeGet = PublishRelay<Void>()
    let selectWhatLikeGet = PublishRelay<FPWhatLikeGetCell.Tag>()
    let setRadius = PublishRelay<FPTableRadiusBundle>()
    let createTrip = PublishRelay<Void>()
    
    var selectedWhatLikeGetTag: FPWhatLikeGetCell.Tag?
    var radiusBundle = FPTableRadiusBundle()
    
    private let geoLocationManager = GeoLocationManager(mode: .whenInUseAuthorization)
    private let tripManager = TripManagerCore()
    
    private let needPaygateTrigger = PublishRelay<Void>()
    private let tripCreatedTrigger = PublishRelay<Void>()
    
    func newSection() -> Driver<FindPlaceTableSection> {
        let sections = Driver<FindPlaceTableSection>
            .merge([
                receiveRequireGeoPermission(),
                receiveFindCoordinate(),
                receiveWhatLikeGet(),
                receiveSelectWhatLikeGet(),
                receiveFindGeoPermissionStatus(),
                receiveCreateTripForCreatePreloaderSection(),
                receiveCreateTripForCreateResultSection(),
                receiveSelectRadiusForNextSection()
            ])
        
        let mapLoadDelay = createMapLoadDelay()
        
        return mapLoadDelay.flatMapLatest { sections }
    }
    
    func replaceSection() -> Driver<FindPlaceTableSection> {
        Driver
            .merge([
                receiveSelectWhatLikeGetForReplace(),
                receiveSelectRadiusForReplace(),
            ])
    }
    
    func currentCoordinate() -> Driver<Coordinate> {
        geoLocationManager.rx
            .justDetermineCurrentLocation
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func needPaygate() -> Driver<Void> {
        needPaygateTrigger
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func tripCreated() -> Driver<Void> {
        tripCreatedTrigger
            .asDriver(onErrorDriveWith: .empty())
    }
}

// MARK: Private

private extension FindPlaceViewModel {
    // Delay for map will load
    func createMapLoadDelay() -> Driver<Void> {
        reset
            .do(onNext: { [weak self] in
                self?.selectedWhatLikeGetTag = nil
                self?.radiusBundle.setDefault()
            })
            .startWith(Void())
            .flatMapLatest {
                Observable<Void>
                    .create { event in
                        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 1) {
                            DispatchQueue.main.async {
                                event.onNext(Void())
                                event.onCompleted()
                            }
                        }
                
                        return Disposables.create()
                    }
            }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func receiveFindGeoPermissionStatus() -> Driver<FindPlaceTableSection> {
        findGeoPermissionStatus
            .startWith(Void())
            .flatMap { [geoLocationManager] _ -> Observable<FindPlaceTableSection> in
                Observable<FindPlaceTableSection>.create { [weak self] event in
                    switch geoLocationManager.authorizationStatus {
                    case .authorization:
                        self?.findCoordinate.accept(Void())
                        
                        event.onNext(FindPlaceTableSection(identifier: FindPlaceTableSection.Identifiers.notification,
                                                           items: [.notification("FindPlace.FPSearchingCoordinateCell.Title".localized)]))
                    case .denied:
                        event.onNext(FindPlaceTableSection(identifier: FindPlaceTableSection.Identifiers.deniedGeoPermission,
                                                           items: [.deniedGeoPermission]))
                        
                        event.onNext(FindPlaceTableSection(identifier: FindPlaceTableSection.Identifiers.requireGeoPermission,
                                                           items: [.requireGeoPermission]))
                    case .notDetermined:
                        event.onNext(FindPlaceTableSection(identifier: FindPlaceTableSection.Identifiers.requireGeoPermission,
                                                           items: [.requireGeoPermission]))
                    }
                    
                    event.onCompleted()
                    
                    return Disposables.create()
                }
            }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func receiveRequireGeoPermission() -> Driver<FindPlaceTableSection> {
        requireGeoPermission
            .flatMap { [geoLocationManager] _ -> Observable<FindPlaceTableSection> in
                Observable<FindPlaceTableSection>.create { event in
                    geoLocationManager.requestAuthorization { [weak self] status in
                        switch status {
                        case .denied:
                            event.onNext(FindPlaceTableSection(identifier: FindPlaceTableSection.Identifiers.deniedGeoPermission,
                                                               items: [.deniedGeoPermission]))
                            
                            event.onNext(FindPlaceTableSection(identifier: FindPlaceTableSection.Identifiers.requireGeoPermission,
                                                               items: [.requireGeoPermission]))
                            
                            event.onCompleted()
                        case .authorization:
                            self?.findCoordinate.accept(Void())
                            
                            event.onNext(FindPlaceTableSection(identifier: FindPlaceTableSection.Identifiers.notification,
                                                               items: [.notification("FindPlace.FPSearchingCoordinateCell.Title".localized)]))
                            event.onCompleted()
                        default:
                            break
                        }
                    }
                    
                    return Disposables.create()
                }
            }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func receiveFindCoordinate() -> Driver<FindPlaceTableSection> {
        findCoordinate
            .flatMap { [geoLocationManager] in
                Observable<FindPlaceTableSection>.create { event in
                    geoLocationManager.justDetermineCurrentLocation { [weak self] coordinate in
                        let section = FindPlaceTableSection(identifier: FindPlaceTableSection.Identifiers.searchedCoordinate,
                                                            items: [.searchedCoordinate(coordinate)])
                        
                        event.onNext(section)
                        event.onCompleted()
                        
                        self?.whatLikeGet.accept(Void())
                    }
                    
                    return Disposables.create {
                        geoLocationManager.stopUpdatingLocation()
                    }
                }
            }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func receiveWhatLikeGet() -> Driver<FindPlaceTableSection> {
        whatLikeGet
            .flatMap {
                Observable<FindPlaceTableSection>.create { [weak self] event in
                    DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 1) {
                        DispatchQueue.main.async {
                            let section = FindPlaceTableSection(identifier: FindPlaceTableSection.Identifiers.whatLikeGet,
                                                                items: [.whatLikeGet(self?.selectedWhatLikeGetTag)])
                            
                            event.onNext(section)
                            event.onCompleted()
                        }
                    }
                    
                    return Disposables.create()
                }
            }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func receiveSelectWhatLikeGet() -> Driver<FindPlaceTableSection> {
        selectWhatLikeGet
            .flatMap { tag -> Observable<FindPlaceTableSection> in
                Observable<FindPlaceTableSection>
                    .create { [weak self] event in
                        guard let this = self else {
                            return Disposables.create()
                        }
                        
                        if tag == .whatItIs {
                            event.onNext(FindPlaceTableSection(identifier: FindPlaceTableSection.Identifiers.whatItis,
                                                               items: [.whatItis]))
                            event.onNext(FindPlaceTableSection(identifier: FindPlaceTableSection.Identifiers.whatLikeGet,
                                                               items: [.whatLikeGet(this.selectedWhatLikeGetTag)]))
                        } else {
                            event.onNext(FindPlaceTableSection(identifier: FindPlaceTableSection.Identifiers.radius,
                                                               items: [.radius(this.radiusBundle)]))
                        }
                        
                        event.onCompleted()
                        
                        return Disposables.create()
                    }
            }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func receiveSelectWhatLikeGetForReplace() -> Driver<FindPlaceTableSection> {
        selectWhatLikeGet
            .filter {
                $0 != .whatItIs
            }
            .do(onNext: { [weak self] tag in
                self?.selectedWhatLikeGetTag = tag
            })
            .map { FindPlaceTableSection(identifier: FindPlaceTableSection.Identifiers.whatLikeGet,
                                         items: [.whatLikeGet($0)]) }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func receiveSelectRadiusForReplace() -> Driver<FindPlaceTableSection> {
        setRadius
            .do(onNext: { [weak self] bundle in
                self?.radiusBundle = bundle
            })
            .map { FindPlaceTableSection(identifier: FindPlaceTableSection.Identifiers.radius,
                                         items: [.radius($0)]) }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func receiveSelectRadiusForNextSection() -> Driver<FindPlaceTableSection> {
        setRadius
            .map { _ in
                FindPlaceTableSection(identifier: FindPlaceTableSection.Identifiers.complete,
                                      items: [.complete])
            }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func receiveCreateTripForCreatePreloaderSection() -> Driver<FindPlaceTableSection> {
        createTrip
            .map { FindPlaceTableSection(identifier: FindPlaceTableSection.Identifiers.notification,
                                         items: [.notification("FindPlace.HasCreatingTrip".localized)]) }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func receiveCreateTripForCreateResultSection() -> Driver<FindPlaceTableSection> {
        createTrip
            .flatMapLatest { [weak self] _ -> Observable<FindPlaceTableSection> in
                guard let this = self else {
                    return .empty()
                }
                
                defer { this.geoLocationManager.justDetermineCurrentLocation() }
                
                return this.geoLocationManager.rx
                    .justDetermineCurrentLocation
                    .asObservable()
                    .flatMapLatest { coordinate -> Single<FindPlaceTableSection?> in
                        this.tripManager
                            .rxCreateTrip(with: GeoLocationUtils.findCoordinate(from: coordinate, on: Double(this.radiusBundle.radius)))
                            .map { success -> FindPlaceTableSection? in
                                success ? nil : FindPlaceTableSection(identifier: "FindPlaceTableSection.Identifiers.notification",
                                                                      items: [.notification("FindPlace.CreateTrip.Failure".localized)])
                            }
                            .do(onError: { [weak self] error in
                                if ErrorChecker.needPayment(in: error) {
                                    self?.needPaygateTrigger.accept(Void())
                                }
                            })
                            .catchError { error in
                                if ErrorChecker.needPayment(in: error) {
                                    return .just(nil)
                                }
                                
                                let section = FindPlaceTableSection(identifier: "FindPlaceTableSection.Identifiers.notification",
                                                                    items: [.notification("FindPlace.CreateTrip.Failure".localized)])
                                
                                return .just(section)
                            }
                    }
                    .flatMap { [weak self] section -> Observable<FindPlaceTableSection> in
                        guard let section = section else {
                            self?.tripCreatedTrigger.accept(Void())
                            return .empty()
                        }
                        
                        return .just(section)
                    }
            }
            .asDriver(onErrorDriveWith: .empty())
    }
}
