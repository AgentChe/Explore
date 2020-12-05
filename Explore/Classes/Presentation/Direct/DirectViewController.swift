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
            .sections
            .drive(onNext: { [weak self] sections in
                self?.directView.collectionView.setup(sections: sections)
            })
            .disposed(by: disposeBag)
        
        directView
            .collectionView.rx
            .didSelectElement
            .emit(onNext: { [weak self] element in
                self?.viewModel.didSelectElement.accept(element)
                self?.logEvent(at: element)
            })
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

// MARK: JournalViewControllerDelegate
extension DirectViewController: JournalViewControllerDelegate {
    func journalViewControllerNeedPayment() {
        navigationController?.popViewController(animated: true)
        
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
            
            navigationController?.pushViewController(mapVC, animated: true)
        case .learn:
            let learnVC = LearnCategoriesViewController.make()
            learnVC.delegate = self
            
            navigationController?.pushViewController(learnVC, animated: true)
        case .wallpapers:
            let wallpapersVC = WallpapersViewController.make()
            wallpapersVC.delegate = self
            
            navigationController?.pushViewController(wallpapersVC, animated: true)
        case .journal:
            let journalVC = JournalViewController.make()
            journalVC.delegate = self 
            
            navigationController?.pushViewController(journalVC, animated: true)
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
    
    func logEvent(at element: DirectCollectionElement) {
        switch element {
        case .explore:
            SDKStorage.shared
                .amplitudeManager
                .logEvent(name: "Index Tap", parameters: ["what": "explore"])
        case .learn:
            SDKStorage.shared
                .amplitudeManager
                .logEvent(name: "Index Tap", parameters: ["what": "learn"])
        case .wallpapers:
            SDKStorage.shared
                .amplitudeManager
                .logEvent(name: "Index Tap", parameters: ["what": "see"])
        case .join:
            SDKStorage.shared
                .amplitudeManager
                .logEvent(name: "Index Tap", parameters: ["what": "join"])
        default:
            break
        }
    }
}
