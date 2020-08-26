//
//  SplashViewController.swift
//  Explore
//
//  Created by Andrey Chernyshev on 07.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class SplashViewController: UIViewController {
    var splashView = SplashView()
    
    override func loadView() {
        super.loadView()
        
        view = splashView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) { [weak self] in
            self?.navigate()
        }
    }
}

// MARK: Make

extension SplashViewController {
    static func make() -> SplashViewController {
        SplashViewController()
    }
}

// MARK: Private

private extension SplashViewController {
    func navigate() {
        
    }
}
