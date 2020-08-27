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
    var findPlaceView = FindPlaceView()
    
    private let viewModel = FindPlaceViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        view = findPlaceView
    }
}

// MARK: Make

extension FindPlaceViewController {
    static func make() -> FindPlaceViewController {
        FindPlaceViewController()
    }
}
