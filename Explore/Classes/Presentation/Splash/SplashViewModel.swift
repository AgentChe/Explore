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
        case onboarding, direct
    }
    
    lazy var step = createStep()
    
    private let paygateConfigurationManager = PaygateConfigurationManagerCore()
}

// MARK: Private

private extension SplashViewModel {
    func createStep() -> Single<Step> {
        let step = Single.deferred {
            Single<Step>.just(OnboardingViewController.wasViewed ? Step.direct : Step.onboarding)
        }
        
        return initiale()
            .andThen(step)
    }
    
    func initiale() -> Completable {
        paygateConfigurationManager
            .rxRetrieveConfiguration()
            .asCompletable()
    }
}
