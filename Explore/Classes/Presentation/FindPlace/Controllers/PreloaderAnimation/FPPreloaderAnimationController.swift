//
//  FPPreloaderAnimationController.swift
//  Explore
//
//  Created by Andrey Chernyshev on 05.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class FPPreloaderAnimationController: UIViewController {
    var mainView = FPPreloaderAnimationView()
    
    private let tripCreatedTrigger: Driver<CreateTripResult>
    private let complete: ((CreateTripResult) -> Void)
    
    private let disposeBag = DisposeBag()
    
    private init(tripCreatedTrigger: Driver<CreateTripResult>, complete: @escaping ((CreateTripResult) -> Void)) {
        self.tripCreatedTrigger = tripCreatedTrigger
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
        
        tripCreatedTrigger
            .delay(RxTimeInterval.seconds(Int.random(in: 4...6)))
            .drive(onNext: complete)
            .disposed(by: disposeBag)
        
        startAnimation()
    }
}

// MARK: Make
extension FPPreloaderAnimationController {
    static func make(tripCreatedTrigger: Driver<CreateTripResult>, complete: @escaping ((CreateTripResult) -> Void)) -> FPPreloaderAnimationController {
        let vc = FPPreloaderAnimationController(tripCreatedTrigger: tripCreatedTrigger, complete: complete)
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}

// MARK: Private
private extension FPPreloaderAnimationController {
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
