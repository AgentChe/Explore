//
//  SplashViewModel.swift
//  Explore
//
//  Created by Andrey Chernyshev on 27.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift
import RxCocoa

final class SplashViewModel {
    enum Step {
        case onboarding, findPlace, map
    }
    
    private let tripManager = TripManager()
    
    lazy var step = createStep()
}

// MARK: Private

private extension SplashViewModel {
    func createStep() -> Single<Step> {
        .deferred { [tripManager] in
            if tripManager.hasTrip() {
                return .just(Step.map)
            } else {
                return .just(OnboardingViewController.wasViewed ? Step.findPlace : Step.onboarding)
            }
        }
    }
}
