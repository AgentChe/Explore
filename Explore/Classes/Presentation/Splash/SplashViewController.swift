//
//  SplashViewController.swift
//  Explore
//
//  Created by Andrey Chernyshev on 07.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class SplashViewController: UIViewController {
    var splashView = SplashView()
    
    private let viewModel = SplashViewModel()
    
    private let disposeBag = DisposeBag()
    
    private let generateStep: Signal<Void>
    
    private init(generateStep: Signal<Void>) {
        self.generateStep = generateStep
        
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = splashView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateStep
            .flatMapLatest { [viewModel] in
                viewModel.step.asSignal(onErrorSignalWith: .empty())
            }
            .delay(RxTimeInterval.seconds(1))
            .emit(onNext: { step in
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
    static func make(generateStep: Signal<Void>) -> SplashViewController {
        SplashViewController(generateStep: generateStep)
    }
}
