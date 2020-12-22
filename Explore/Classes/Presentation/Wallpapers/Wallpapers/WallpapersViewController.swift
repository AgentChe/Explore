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
    var wallpapersView = WallpapersView()
    
    private let viewModel = WallpapersViewModel()
    
    private let disposeBag = DisposeBag()
    
    private let categoryId: Int
    
    private init(categoryId: Int) {
        self.categoryId = categoryId
        
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = wallpapersView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel
            .section(for: categoryId)
            .drive(onNext: { [weak self] section in
                self?.wallpapersView.collectionView.setup(section: section)
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
    static func make(categoryId: Int) -> WallpapersViewController {
        WallpapersViewController(categoryId: categoryId)
    }
}

// MARK: Private
private extension WallpapersViewController {
    func showWallpaper(_ wallpaper: Wallpaper) {
        let vc = WallpaperViewController.make(wallpaper: wallpaper)
        navigationController?.present(vc, animated: true)
    }
}
