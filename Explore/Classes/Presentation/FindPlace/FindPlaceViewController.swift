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
    
    private let tripManager: TripManager = TripManagerMock()
    
    override func loadView() {
        super.loadView()
        
        view = findPlaceView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        findPlaceView
            .button.rx.tap
            .flatMapLatest { [tripManager] in
                tripManager.rxCreateTrip(with: Coordinate(latitude: 37.73189401, longitude: -122.42162013))
            }
            .subscribe(onNext: { success in
                if success {
                    UIApplication.shared.keyWindow?.rootViewController = MapViewController.make()
                } else {
                    Toast.notify(with: "Failed", style: .danger)
                }
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
