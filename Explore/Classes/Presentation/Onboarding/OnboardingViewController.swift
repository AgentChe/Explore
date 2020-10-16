//
//  OnboardingViewController.swift
//  Explore
//
//  Created by Andrey Chernyshev on 27.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import RxSwift

final class OnboardingViewController: UIViewController {
    var onboardingView = OnboardingView()
    
    private struct Constants {
        static let wasOpenedKey = "onboarding_view_controller_was_opened"
    }
    
    private let slides: [OnboardingSlide] = [
        .init(imageName: "Onboarding.Icon.Slide1", title: "Onboarding.Slide1.Title".localized, subTitle: nil),
        .init(imageName: "Onboarding.Icon.Slide2", title: "Onboarding.Slide2.Title".localized, subTitle: "Onboarding.Slide2.SubTitle".localized),
        .init(imageName: nil, title: nil, subTitle: nil)
    ]
    
    private let viewModel = OnboardingViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        view = onboardingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        markAsViewed()
        setupSlider()
        
        viewModel
            .step
            .drive(onNext: { [weak self] step in
                switch step {
                case .direct:
                    UIApplication.shared.keyWindow?.rootViewController = DirectNavigationController(rootViewController: DirectViewController.make())
                case .paygate:
                    let vc = PaygateViewController.make()
                    vc.delegate = self
                    self?.present(vc, animated: true)
                }
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

// MARK: API
extension OnboardingViewController {
    static var wasViewed: Bool {
        UserDefaults.standard.bool(forKey: Constants.wasOpenedKey)
    }
}

// MARK: OnboardingSliderDelegate
extension OnboardingViewController: OnboardingSliderDelegate {
    func onboardingSlider(changed slideIndex: Int) {
        if slideIndex == slides.count - 1 {
            viewModel.end.accept(Void())
        }
    }
}

// MARK: PaygateViewControllerDelegate
extension OnboardingViewController: PaygateViewControllerDelegate {
    func paygateDidClosed(with result: PaygateViewControllerResult) {
        UIApplication.shared.keyWindow?.rootViewController = DirectNavigationController(rootViewController: DirectViewController.make())
    }
}

// MARK: Private
extension OnboardingViewController {
    func markAsViewed() {
        UserDefaults.standard.set(true, forKey: Constants.wasOpenedKey)
    }
    
    func setupSlider() {
        onboardingView.slider.setup(models: slides)
        onboardingView.slider.delegate = self
    }
}
