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
    let whatYourSearchIntent = PublishRelay<Void>()
    let selectWhatYourSearchIntent = PublishRelay<FPWhatYourSearchIntentCell.Tag>()
    let whatLikeGet = PublishRelay<Void>()
    let selectWhatLikeGet = PublishRelay<FPWhatLikeGetCell.Tag>()
    let setRadius = PublishRelay<FPTableRadiusBundle>()
    let createTrip = PublishRelay<Void>()
    
    var selectedWhatYourSearchIntentTag: FPWhatYourSearchIntentCell.Tag?
    var selectedWhatLikeGetTag: FPWhatLikeGetCell.Tag?
    var radiusBundle = FPTableRadiusBundle()
    
    private var lastGeoPermissionStatus: GLAuthorizationStatus?
    
    private let geoLocationManager = GeoLocationManager(mode: .whenInUseAuthorization)
    private let tripManager = TripManagerMock() // TODO
    
    func newSection() -> Driver<FindPlaceTableSection> {
        let sections = Driver<FindPlaceTableSection>
            .merge([
                receiveRequireGeoPermission(),
                receiveFindCoordinate(),
                receiveWhatYourSearch(),
                receiveSelectWhatYourSearch(),
                receiveWhatLikeGet(),
                receiveSelectWhatLikeGet(),
                receiveFindGeoPermissionStatus(),
                receiveSelectRadiusForNextSection()
            ])
        
        let mapLoadDelay = createMapLoadDelay()
        
        return mapLoadDelay.flatMapLatest { sections }
    }
    
    func replaceSection() -> Driver<FindPlaceTableSection> {
        Driver
            .merge([
                receiveSelectWhatYourSearchForReplace(),
                receiveSelectWhatLikeGetForReplace(),
                receiveSelectRadiusForReplace(),
            ])
    }
    
    func replaceOrAddSection() -> Driver<FindPlaceTableSection> {
        receiveBecomeAppForCheckGLAuthStatus()
    }
    
    func currentCoordinate() -> Driver<Coordinate> {
        geoLocationManager.rx
            .justDetermineCurrentLocation
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func tripCreated() -> Driver<CreateTripResult> {
        createTrip
            .flatMapLatest { [weak self] void -> Observable<CreateTripResult> in
                guard let this = self else {
                    return .never()
                }
                
                defer {
                    this.geoLocationManager.justDetermineCurrentLocation()
                }
                
                return this.geoLocationManager.rx
                    .justDetermineCurrentLocation
                    .asObservable()
                    .take(1)
                    .flatMapLatest { coordinate -> Single<CreateTripResult> in
                        this.tripManager
                            .rxCreateTrip(with: GeoLocationUtils.findCoordinate(from: coordinate, on: Double(this.radiusBundle.radius)))
                            .map { success -> CreateTripResult in
                                success ? .success : .failure
                            }
                            .catchError { error in
                                .just(ErrorChecker.needPayment(in: error) ? .needPayment : .failure)
                            }
                    }
            }
            .asDriver(onErrorDriveWith: .empty())
    }
}

// MARK: Private
private extension FindPlaceViewModel {
    // Delay for map will load
    func createMapLoadDelay() -> Driver<Void> {
        reset
            .do(onNext: { [weak self] in
                self?.lastGeoPermissionStatus = nil
                self?.selectedWhatYourSearchIntentTag = nil
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
    
    func receiveBecomeAppForCheckGLAuthStatus() -> Driver<FindPlaceTableSection> {
        let storeLastStatus = AppStateManager.shared
            .rxWillResignApplication
            .do(onNext: { [weak self] in
                guard let this = self else {
                    return
                }
                
                this.lastGeoPermissionStatus = this.geoLocationManager.authorizationStatus
            })
            .flatMap { _ -> Driver<FindPlaceTableSection> in .never() }
        
        let become = AppStateManager.shared
            .rxDidBecomeApplication
            .flatMap { [weak self] _ -> Driver<FindPlaceTableSection> in
                guard let this = self else {
                    return .empty()
                }
                
                guard this.lastGeoPermissionStatus == .denied else {
                    return .never()
                }
                
                switch this.geoLocationManager.authorizationStatus {
                case .authorization:
                    this.findCoordinate.accept(Void())
                    
                    return .never()
                case .notDetermined:
                    return .just(FindPlaceTableSection(identifier: FindPlaceTableSection.Identifiers.requireGeoPermission,
                                                       items: [.requireGeoPermission]))
                default:
                    return .never()
                }
            }
        
        return Driver.merge(storeLastStatus, become)
    }
    
    func receiveFindCoordinate() -> Driver<FindPlaceTableSection> {
        findCoordinate
            .flatMap { [geoLocationManager] _ -> Single<FindPlaceTableSection> in
                defer {
                    geoLocationManager.justDetermineCurrentLocation()
                }
                
                return geoLocationManager
                    .rx.justDetermineCurrentLocation
                    .asObservable()
                    .take(1)
                    .map {
                        FindPlaceTableSection(identifier: FindPlaceTableSection.Identifiers.searchedCoordinate,
                                              items: [.searchedCoordinate($0)])
                    }
                    .asSingle()
                    .do(onSuccess: { [weak self] _ in
                        self?.whatYourSearchIntent.accept(Void())
                    })
            }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func receiveWhatYourSearch() -> Driver<FindPlaceTableSection> {
        whatYourSearchIntent
            .flatMap {
                Observable<FindPlaceTableSection>.create { [weak self] event in
                    DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 1) {
                        DispatchQueue.main.async {
                            let section = FindPlaceTableSection(identifier: FindPlaceTableSection.Identifiers.whatYourSearchIntent,
                                                                items: [.whatYourSearchIntent(self?.selectedWhatYourSearchIntentTag)])
                            
                            event.onNext(section)
                            event.onCompleted()
                        }
                    }
                    
                    return Disposables.create()
                }
            }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func receiveSelectWhatYourSearch() -> Driver<FindPlaceTableSection> {
        selectWhatYourSearchIntent
            .flatMap { tag -> Observable<FindPlaceTableSection> in
                Observable<FindPlaceTableSection>
                    .create { [weak self] event in
                        guard let this = self else {
                            return Disposables.create()
                        }
                        
                        if tag == .whatThis {
                            event.onNext(FindPlaceTableSection(identifier: FindPlaceTableSection.Identifiers.whatItis,
                                                               items: [.whatItis("FindPlace.FPWhatItIsCell.Message2".localized)]))
                            event.onNext(FindPlaceTableSection(identifier: FindPlaceTableSection.Identifiers.whatYourSearchIntent,
                                                               items: [.whatYourSearchIntent(this.selectedWhatYourSearchIntentTag)]))
                        } else {
                            event.onNext(FindPlaceTableSection(identifier: FindPlaceTableSection.Identifiers.whatLikeGet,
                                                               items: [.whatLikeGet(this.selectedWhatLikeGetTag)]))
                        }
                        
                        event.onCompleted()
                        
                        return Disposables.create()
                    }
            }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func receiveSelectWhatYourSearchForReplace() -> Driver<FindPlaceTableSection> {
        selectWhatYourSearchIntent
            .filter {
                $0 != .whatThis
            }
            .do(onNext: { [weak self] tag in
                self?.selectedWhatYourSearchIntentTag = tag
            })
            .map { FindPlaceTableSection(identifier: FindPlaceTableSection.Identifiers.whatYourSearchIntent,
                                         items: [.whatYourSearchIntent($0)]) }
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
                                                               items: [.whatItis("FindPlace.FPWhatItIsCell.Message".localized)]))
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
}
