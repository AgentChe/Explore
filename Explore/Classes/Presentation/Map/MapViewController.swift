//
//  MapViewController.swift
//  Explore
//
//  Created by Andrey Chernyshev on 27.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import RxSwift

final class MapViewController: UIViewController {
    var mapView = MapView()
    
    private let viewModel = MapViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        view = mapView
    }
}

// MARK: Make

extension MapViewController {
    static func make() -> MapViewController {
        MapViewController()
    }
}
