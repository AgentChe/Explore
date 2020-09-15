//
//  DirectViewController.swift
//  Explore
//
//  Created by Andrey Chernyshev on 14.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import RxSwift

final class DirectViewController: UIViewController {
    var directView = DirectView()
    
    private let viewModel = DirectViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        view = directView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel
            .elements
            .drive(onNext: { [weak self] elements in
                self?.directView.collectionView.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        directView
            .collectionView.rx
            .didSelectElement
            .emit(to: viewModel.didSelectElement)
            .disposed(by: disposeBag)
        
        viewModel
            .step
            .drive(onNext: { [weak self] step in
                self?.navigate(at: step)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make

extension DirectViewController {
    static func make() -> DirectViewController {
        DirectViewController()
    }
}

// MARK: FindPlaceViewControllerDelegate

extension DirectViewController: FindPlaceViewControllerDelegate {
    func findPlaceViewControllerTripCreated() {
        navigationController?.popViewController(animated: false)
        
        navigate(at: .map)
    }
    
    func findPlaceViewControllerNeedPayment() {
        showPaygate()
    }
}

// MARK: MapViewControllerDelegate

extension DirectViewController: MapViewControllerDelegate {
    func mapViewControllerTripRemoved() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: Private

private extension DirectViewController {
    func navigate(at step: DirectViewModel.Step) {
        let vc: UIViewController
        
        switch step {
        case .findPlace:
            let findPlaceVC = FindPlaceViewController.make()
            findPlaceVC.delegate = self
            
            vc = findPlaceVC
        case .map:
            let mapVC = MapViewController.make()
            mapVC.delegate = self
            
            vc = mapVC
        case .learn:
            vc = LearnViewController.make()
        case .wallpapers:
            vc = WallpapersViewController.make()
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showPaygate() {
        let vc = PaygateViewController.make()
        navigationController?.present(vc, animated: true)
    }
}
