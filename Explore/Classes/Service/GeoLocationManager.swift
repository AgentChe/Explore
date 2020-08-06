//
//  GeoLocationManager.swift
//  Explore
//
//  Created by Andrey Chernyshev on 05.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import CoreLocation
import RxSwift
import RxCocoa

final class GeoLocationManager: NSObject {
    enum Mode {
        case alwaysAuthorization, whenInUseAuthorization
    }
    
    private enum UpdateLocationMode {
        case justDetermineCurrentLocation, continuoslyKeepLocation
    }
    
    var failed: ((Error) -> ())? = nil
    
    private let manager = CLLocationManager()
    
    fileprivate let changedAuthorizationStatusSubject = PublishRelay<GLAuthorizationStatus>()
    fileprivate let justDetermineCurrentLocationSubject = PublishRelay<Coordinate>()
    fileprivate let continuoslyKeepCurrentLocationSubject = PublishRelay<Coordinate>()
    fileprivate let failedSubject = PublishRelay<Error>()
    
    private var requestAuthorizationHander: ((GLAuthorizationStatus) -> ())? = nil
    private var justDetermineCurrentLocationHandler: ((Coordinate) -> Void)? = nil
    private var continuoslyKeepLocationHandler: ((Coordinate) -> Void)? = nil
    
    private var delegates = [Weak<GeoLocationManagerDelegate>]()
    
    private let mode: Mode
    private var updateLocationMode: UpdateLocationMode?
    
    init(mode: Mode) {
        self.mode = mode
        
        super.init()
        
        manager.delegate = self
    }
    
    func justDetermineCurrentLocation(handler: ((Coordinate) -> Void)? = nil) {
        updateLocationMode = .justDetermineCurrentLocation
        
        justDetermineCurrentLocationHandler = handler
        
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        manager.requestLocation()
    }
    
    func continuoslyKeepLocation(handler: ((Coordinate) -> Void)? = nil) {
        updateLocationMode = .continuoslyKeepLocation
        
        continuoslyKeepLocationHandler = handler
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 10
        
        manager.requestLocation()
    }
    
    func requestAuthorization(handler: ((GLAuthorizationStatus) -> ())? = nil) {
        requestAuthorizationHander = handler
        
        switch mode {
        case .alwaysAuthorization:
            manager.requestAlwaysAuthorization()
        case .whenInUseAuthorization:
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func stopUpdatingLocation() {
        manager.stopUpdatingLocation()
    }
    
    var authorizationStatus: GLAuthorizationStatus {
        guard CLLocationManager.locationServicesEnabled() else {
            return .denied
        }
        
        let status = CLLocationManager.authorizationStatus()

        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            if mode == .alwaysAuthorization || mode == .whenInUseAuthorization {
                return .authorization
            } else {
                return .denied
            }
        case .notDetermined:
            return .notDetermined
        default:
            return .denied

        }
    }
}

// MARK: CLLocationManagerDelegate

extension GeoLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        let status = authorizationStatus
        
        changedAuthorizationStatusSubject.accept(status)
        
        requestAuthorizationHander?(status)
        
        delegates.forEach { $0.weak?.geoLocationManager(changed: status) }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let updateLocationMode = self.updateLocationMode else {
            return
        }
        
        guard let location = locations.first?.coordinate else {
            return
        }
        
        let coordinate = Coordinate(latitude: location.latitude, longitude: location.longitude)
        
        switch updateLocationMode {
        case .continuoslyKeepLocation:
            continuoslyKeepLocationHandler?(coordinate)
            
            continuoslyKeepCurrentLocationSubject.accept(coordinate)
            
            delegates.forEach { $0.weak?.geoLocationManager(continuoslyKeep: coordinate) }
        case .justDetermineCurrentLocation:
            justDetermineCurrentLocationHandler?(coordinate)
            
            justDetermineCurrentLocationSubject.accept(coordinate)
            
            delegates.forEach { $0.weak?.geoLocationManager(justDetermine: coordinate) }
            
            stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        failed?(error)
        
        failedSubject.accept(error)
        
        delegates.forEach { $0.weak?.geoLocationManager(error: error) }
    }
}

// MARK: Rx

extension Reactive where Base: GeoLocationManager {
    var changedAuthorizationStatus: Signal<GLAuthorizationStatus> {
        base.changedAuthorizationStatusSubject.asSignal()
    }
    
    var justDetermineCurrentLocation: Signal<Coordinate> {
        base.justDetermineCurrentLocationSubject.asSignal()
    }
    
    var continuoslyKeepCurrentLocation: Signal<Coordinate> {
        base.continuoslyKeepCurrentLocationSubject.asSignal()
    }
    
    var failed: Signal<Error> {
        base.failedSubject.asSignal()
    }
}

// MARK: Observer

extension GeoLocationManager {
    func add(observer: GeoLocationManagerDelegate) {
        let weakly = observer as AnyObject
        delegates.append(Weak<GeoLocationManagerDelegate>(weakly))
        delegates = delegates.filter { $0.weak != nil }
    }
    
    func remove(observer: GeoLocationManagerDelegate) {
        if let index = delegates.firstIndex(where: { $0.weak === observer }) {
            delegates.remove(at: index)
        }
    }
}
