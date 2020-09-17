//
//  WallpapersViewController.swift
//  Explore
//
//  Created by Andrey Chernyshev on 15.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import RxSwift

final class WallpapersViewController: UIViewController {
    weak var delegate: WallpapersViewControllerDelegate?
    
    var wallpapersView = WallpapersView()
    
    private let viewModel = WallpapersViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        view = wallpapersView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel
            .needPayment
            .emit(onNext: { [weak self] in
                self?.delegate?.wallpapersViewControllerNeedPayment()
            })
            .disposed(by: disposeBag)
        
        viewModel
            .elements
            .drive(onNext: { [weak self] elements in
                self?.wallpapersView.collectionView.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        wallpapersView
            .collectionView.rx
            .didSelectWallpaper
            .emit(onNext: { [weak self] wallpaper in
                self?.showWallpaper(wallpaper)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make

extension WallpapersViewController {
    static func make() -> WallpapersViewController {
        WallpapersViewController()
    }
}

// MARK: Private

private extension WallpapersViewController {
    func showWallpaper(_ wallpaper: Wallpaper) {
        let vc = WallpaperViewController.make(wallpaper: wallpaper)
        navigationController?.present(vc, animated: true)
    }
}
