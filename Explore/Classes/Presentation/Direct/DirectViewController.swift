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
}

// MARK: MapViewControllerDelegate
extension DirectViewController: MapViewControllerDelegate {
    func mapViewControllerTripRemoved() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: WallpapersViewControllerDelegate
extension DirectViewController: WallpapersViewControllerDelegate {
    func wallpapersViewControllerNeedPayment() {
        navigationController?.popViewController(animated: false)
        
        showPaygate()
    }
}

// MARK: LearnCategoriesViewControllerDelegate
extension DirectViewController: LearnCategoriesViewControllerDelegate {
    func learnCategoriesViewControllerNeedPayment() {
        navigationController?.popViewController(animated: false)
        
        showPaygate()
    }
}

// MARK: Private
private extension DirectViewController {
    func navigate(at step: DirectViewModel.Step) {
        switch step {
        case .findPlace:
            let findPlaceVC = FindPlaceViewController.make()
            findPlaceVC.delegate = self
            
            navigationController?.pushViewController(findPlaceVC, animated: true)
        case .map:
            let mapVC = MapViewController.make()
            mapVC.delegate = self
            
            navigationController?.pushViewController(mapVC, animated: true)
        case .learn:
            let learnVC = LearnCategoriesViewController.make()
            learnVC.delegate = self
            
            navigationController?.pushViewController(learnVC, animated: true)
        case .wallpapers:
            let wallpapersVC = WallpapersViewController.make()
            wallpapersVC.delegate = self
            
            navigationController?.pushViewController(wallpapersVC, animated: true)
        case .join:
            join()
        case .paygate:
            showPaygate()
        }
    }
    
    func showPaygate() {
        let vc = PaygateViewController.make()
        navigationController?.present(vc, animated: true)
    }
    
    func join() {
        guard let url = URL(string: "https://www.reddit.com/r/randonauts/") else {
            return
        }
        
        UIApplication.shared.open(url, options: [:])
    }
}
