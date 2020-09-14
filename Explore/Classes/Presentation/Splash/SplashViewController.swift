//
//  SplashViewController.swift
//  Explore
//
//  Created by Andrey Chernyshev on 07.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import RxSwift

final class SplashViewController: UIViewController {
    var splashView = SplashView()
    
    private let viewModel = SplashViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        view = splashView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel
            .step
            .delaySubscription(RxTimeInterval.seconds(1), scheduler: ConcurrentMainScheduler.instance)
            .subscribe(onSuccess: { step in
                switch step {
                case .onboarding:
                    UIApplication.shared.keyWindow?.rootViewController = OnboardingViewController.make()
                case .direct:
                    UIApplication.shared.keyWindow?.rootViewController = DirectNavigationController(rootViewController: DirectViewController.make())
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make

extension SplashViewController {
    static func make() -> SplashViewController {
        SplashViewController()
    }
}
