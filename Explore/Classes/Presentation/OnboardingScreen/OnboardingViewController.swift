//
//  OnboardingViewController.swift
//  Explore
//
//  Created by Andrey Chernyshev on 07.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import RxSwift

final class OnboardingViewController: UIViewController {
    var onboardingView = OnboardingView()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        view = onboardingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onboardingView
            .okButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.markAsOpened()
                self?.goToMapScreen()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make

extension OnboardingViewController {
    static func make() -> OnboardingViewController {
        OnboardingViewController()
    }
}

// MARK: Static API

extension OnboardingViewController {
    static var isOpened: Bool {
        UserDefaults.standard.bool(forKey: Constants.isOpenedKey)
    }
}

// MARK: Private

private extension OnboardingViewController {
    func markAsOpened() {
        UserDefaults.standard.set(true, forKey: Constants.isOpenedKey)
    }
    
    func goToMapScreen() {
        UIApplication.shared.keyWindow?.rootViewController = MapViewController.make()
    }
}

// MARK: Constants

private extension OnboardingViewController {
    struct Constants {
        static let isOpenedKey = "onboarding_view_controller_is_opened_key"
    }
}
