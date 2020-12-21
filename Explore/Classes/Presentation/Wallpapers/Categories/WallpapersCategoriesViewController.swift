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
    lazy var mainView = WCCollectionView()
    
    private let viewModel = WallpapersCategoriesViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
}

// MARK: Make
extension WallpapersCategoriesViewController {
    static func make() -> WallpapersCategoriesViewController {
        WallpapersCategoriesViewController()
    }
}
