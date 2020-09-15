//
//  FindPlaceViewController.swift
//  Explore
//
//  Created by Andrey Chernyshev on 27.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import RxSwift

final class FindPlaceViewController: UIViewController {
    weak var delegate: FindPlaceViewControllerDelegate?
    
    var findPlaceView = FindPlaceView()
    
    private let viewModel = FindPlaceViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        view = findPlaceView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        findPlaceView.tableView.fpTableDelegate = self
        
        viewModel
            .newSection()
            .drive(onNext: { [weak self] section in
                self?.findPlaceView.tableView.add(section: section)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .replaceSection()
            .drive(onNext: { [weak self] section in
                self?.findPlaceView.tableView.replace(section: section)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .currentCoordinate()
            .drive(onNext: { [weak self] coordinate in
                self?.findPlaceView.mapView.moveCamera(to: coordinate)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .needPaygate()
            .drive(onNext: { [weak self] in
                self?.delegate?.findPlaceViewControllerNeedPayment()
            })
            .disposed(by: disposeBag)
        
        viewModel
            .tripCreated()
            .drive(onNext: { [weak self] in
                self?.delegate?.findPlaceViewControllerTripCreated()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make

extension FindPlaceViewController {
    static func make() -> FindPlaceViewController {
        FindPlaceViewController()
    }
}

// MARK: FindPlaceTableDelegate

extension FindPlaceViewController: FindPlaceTableDelegate {
    func findPlaceTableDidRequireGeoPermission() {
        viewModel.requireGeoPermission.accept(Void())
    }
    
    func findPlaceTableDidNavigateToSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }
    
    func findPlaceTableDidSelected(whatLikeGet tag: FPWhatLikeGetCell.Tag) {
        guard viewModel.selectedWhatLikeGetTag == nil else {
            return
        }
        
        viewModel.selectWhatLikeGet.accept(tag)
    }
    
    func findPlaceTableDidSetRadius(radiusBundle: FPTableRadiusBundle) {
        viewModel.setRadius.accept(radiusBundle)
    }
    
    func findPlaceTableDidStart() {
        viewModel.createTrip.accept(Void())
    }
    
    func findPlaceTableDidReset() {
        findPlaceView.tableView.removeAll()
        
        viewModel.reset.accept(Void())
    }
}
