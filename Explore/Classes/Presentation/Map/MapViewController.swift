//
//  MapViewController.swift
//  Explore
//
//  Created by Andrey Chernyshev on 27.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

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
        
        navigationItem.title = "Map.Title".localized
        
        let lifeUpdatingCoordinate = viewModel
            .monitoringOfCoordinate()
        
        let trip = viewModel
            .trip()
        
        lifeUpdatingCoordinate
            .drive(onNext: { [weak self] coordinate in
                self?.mapView.mapView.moveUserPlacedMarker(at: coordinate)
            })
            .disposed(by: disposeBag)
        
        trip
            .drive(onNext: { [weak self] trip in
                self?.updateCamera(at: trip)
            })
            .disposed(by: disposeBag)
        
        let tripInProgress = viewModel.tripInProgress()
        
        tripInProgress
            .drive(onNext: { [weak self] inProgress in
                self?.updateTripButton(inProgress: inProgress)
            })
            .disposed(by: disposeBag)
        
        Driver
            .combineLatest(trip, lifeUpdatingCoordinate)
            .drive(onNext: { [weak self] stub in
                let (trip, coordinate) = stub
                
                guard let this = self, let toTrip = trip else {
                    return
                }
                
                this.updateRadius(from: coordinate, to: toTrip)
            })
            .disposed(by: disposeBag)
        
        mapView
            .tripButton.rx.tap
            .withLatestFrom(tripInProgress)
            .subscribe(onNext: { [weak self] inProgress in
                self?.tripButtonTapped(inProgress: inProgress)
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
    func updateRadius(from location: Coordinate, to trip: Trip) {
        let distance = GeoLocationUtils.distance(from: location, to: trip.toCoordinate)
        
        mapView.radiusLabel.text = String(format: "Map.RadiusToTrip".localized, Int(distance))
    }
    
    func updateCamera(at trip: Trip?) {
        guard let trip = trip else {
            return
        }
        
        mapView.mapView.setTripMarker(at: trip.toCoordinate)
        mapView.mapView.moveCamera(to: trip.toCoordinate)
    }
    
    func updateTripButton(inProgress: Bool) {
        mapView.tripButton.setTitle(inProgress ? "Map.StopTrip".localized : "Map.Navigate".localized, for: .normal)
    }
    
    func tripButtonTapped(inProgress: Bool) {
        if inProgress {
            guard let tripId = viewModel.getTrip()?.id else {
                return
            }
            
            let vc = FeedbackViewController.make(tripId: tripId)
            navigationController?.pushViewController(vc, animated: true)
        } else if isNeedOpenPaygate {
            let vc = PaygateViewController.make()
            present(vc, animated: true)
        } else {
            guard let coordinate = viewModel.getTrip()?.toCoordinate else {
                return
            }
            
            let mapAppsActionSheet = MapAppsActionSheet().alert(coordinate: coordinate) { [weak self] in
                self?.viewModel.addTripToProgress() ?? false
            }
            
            present(mapAppsActionSheet, animated: true)
        }
    }
    
    var isNeedOpenPaygate: Bool {
        guard let config = PaygateConfigurationManagerCore().getConfiguration() else {
            return false
        }
        
        return !config.activeSubscription && config.navigateSpotPaygate
    }
}
