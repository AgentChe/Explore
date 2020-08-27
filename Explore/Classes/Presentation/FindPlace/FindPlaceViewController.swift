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
    
    private let tripManager = TripManager()
    
    override func loadView() {
        super.loadView()
        
        view = findPlaceView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        findPlaceView
            .button.rx.tap
            .subscribe(onNext: {
                self.tripManager.rx.createTrip(with: Coordinate(latitude: 55.8176, longitude: 49.1351)).subscribe()
                
//                self.present(PaygateViewController.make(), animated: true)
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
