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
        .init(imageName: "Onboarding.Slide.1", title: "Onboarding.Slide1.Title".localized, subTitle: nil),
        .init(imageName: "Onboarding.Slide.2", title: "Onboarding.Slide2.Title".localized, subTitle: "Onboarding.Slide2.SubTitle".localized),
        .init(imageName: "Onboarding.Slide.3", title: "Onboarding.Slide3.Title".localized, subTitle: "Onboarding.Slide3.SubTitle".localized),
        .init(imageName: "Onboarding.Slide.4", title: "Onboarding.Slide4.Title".localized, subTitle: "Onboarding.Slide4.SubTitle".localized),
        .init(imageName: "Onboarding.Slide.5", title: "Onboarding.Slide5.Title".localized, subTitle: "Onboarding.Slide5.SubTitle".localized),
        .init(imageName: "Onboarding.Slide.6", title: "Onboarding.Slide6.Title".localized, subTitle: "Onboarding.Slide6.SubTitle".localized)
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
        
        onboardingView
            .enjoyNowButton.rx.tap
            .subscribe(onNext: { [weak self] void in
                self?.startAnimation()
            })
            .disposed(by: disposeBag)
        
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
        onboardingView.indicatorsView.isHidden = slideIndex == slides.count - 1
        onboardingView.enjoyNowButton.isHidden = slideIndex != slides.count - 1
        onboardingView.indicatorsView.index = slideIndex
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
        onboardingView.indicatorsView.count = slides.count
        onboardingView.indicatorsView.index = 0
        onboardingView.slider.delegate = self
    }
    
    func startAnimation() {
        let vc = OnboardingAnimationController.make { [weak self] in
            self?.viewModel.end.accept(Void())
        }
        present(vc, animated: false)
    }
}
