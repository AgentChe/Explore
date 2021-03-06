//
//  WallpapersCategoriesViewController.swift
//  Explore
//
//  Created by Andrey Chernyshev on 21.12.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import RxSwift

final class WallpapersCategoriesViewController: UIViewController {
    lazy var mainView = WallpapersCategoriesView()
    
    private let viewModel = WallpapersCategoriesViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel
            .sections()
            .drive(onNext: mainView.collectionView.setup(sections:))
            .disposed(by: disposeBag)
        
        mainView
            .collectionView.didSelect = tapped(element:)
    }
}

// MARK: Make
extension WallpapersCategoriesViewController {
    static func make() -> WallpapersCategoriesViewController {
        WallpapersCategoriesViewController()
    }
}

// MARK: Private
private extension WallpapersCategoriesViewController {
    func tapped(element: WCCollectionElement) {
        switch element.isLock {
        case true:
            let vc = PaygateViewController.make()
            present(vc, animated: true)
        case false:
            let vc = WallpapersViewController.make(categoryId: element.categoryId)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
