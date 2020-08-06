//
//  MapViewController.swift
//  Explore
//
//  Created by Andrey Chernyshev on 05.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import RxSwift
import GoogleMaps

final class MapViewController: UIViewController {
    var mapView = MapView()
    
    private let viewModel = MapViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        view = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addActions()
        
        viewModel
            .activityIndicator
            .drive(onNext: { [weak self] isActivity in
                self?.preloader(isActivity: isActivity)
            })
            .disposed(by: disposeBag)
        
        let currentCoordinate = viewModel
            .getCurrentCooordinate()
        
        currentCoordinate
            .drive(onNext: { [weak self] coordinate in
                guard let coordinate = coordinate else {
                    return
                }
                
                self?.moveCamera(on: coordinate)
            })
            .disposed(by: disposeBag)
        
        mapView
            .randomizeButton.rx.tap
            .withLatestFrom(currentCoordinate)
            .filter { $0 != nil }
            .map { $0! }
            .bind(to: viewModel.findPlace)
            .disposed(by: disposeBag)
        
        viewModel
            .place()
            .drive(onNext: { [weak self] stub in
                guard let stub = stub else {
                    Toast.notify(with: "Map.FindPlace.Failure".localized, style: .danger)
                    return
                }
                
                let (placeOptional, fromCache) = stub
                
                guard let place = placeOptional else {
                    Toast.notify(with: "Map.FindPlace.Failure".localized, style: .danger)
                    return
                }
                
                if fromCache {
                    Toast.notify(with: "Map.FindPlace.HourNotPassed".localized, style: .warning)
                }
                
                self?.showPlaceInfo(place: place)
                self?.moveCamera(on: place.coordinate)
                self?.mapView.mapView.addPlaceMarker(with: place.coordinate)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make

extension MapViewController {
    static func make() -> MapViewController {
        MapViewController()
    }
}

// MARK: Private

private extension MapViewController {
    func addActions() {
        let placeInfoSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(hidePlaceInfo))
        placeInfoSwipeGesture.direction = .down
        mapView.placeInfoView.addGestureRecognizer(placeInfoSwipeGesture)
        mapView.placeInfoView.isUserInteractionEnabled = true
    }
    
    func showPlaceInfo(place: Place) {
        mapView.randomizeButton.isHidden = true
        
        mapView.placeInfoView.setup(place: place)
        mapView.placeInfoView.isHidden = false
    }
    
    @objc
    func hidePlaceInfo() {
        mapView.randomizeButton.isHidden = false
        
        mapView.placeInfoView.isHidden = true
        
        mapView.mapView.removePlaceMarker()
    }
    
    func preloader(isActivity: Bool) {
        mapView.randomizeButton.setTitle(isActivity ? "" : "Map.Randomize".localized, for: .normal)
        mapView.randomizeButton.isEnabled = !isActivity
        
        isActivity ? mapView.activityIndicator.startAnimating() : mapView.activityIndicator.stopAnimating()
    }
    
    func moveCamera(on coordinate: Coordinate) {
        mapView.mapView.camera = GMSCameraPosition(latitude: coordinate.latitude,
                                                   longitude: coordinate.longitude,
                                                   zoom: 15)
    }
}
