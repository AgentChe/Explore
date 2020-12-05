//
//  OnboardingAnimationController.swift
//  Explore
//
//  Created by Andrey Chernyshev on 06.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class OnboardingAnimationController: UIViewController {
    var mainView = OnboardingAnimationView()
    
    private let disposeBag = DisposeBag()
    
    private let complete: ((UIViewController) -> Void)
    
    private init(complete: @escaping ((UIViewController) -> Void)) {
        self.complete = complete
        
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Single
            .just(self)
            .delaySubscription(RxTimeInterval.seconds(3), scheduler: MainScheduler.asyncInstance)
            .subscribe(onSuccess: complete)
            .disposed(by: disposeBag)
        
        startAnimation()
    }
}

// MARK: Make
extension OnboardingAnimationController {
    static func make(complete: @escaping ((UIViewController) -> Void)) -> OnboardingAnimationController {
        let vc = OnboardingAnimationController(complete: complete)
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}

// MARK: Private
private extension OnboardingAnimationController {
    func startAnimation() {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2)
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = 2
        rotateAnimation.repeatCount = Float.infinity
        mainView.imageView.layer.add(rotateAnimation, forKey: nil)
    }
}
