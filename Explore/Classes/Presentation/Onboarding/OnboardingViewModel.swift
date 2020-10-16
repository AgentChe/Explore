//
//  OnboardingViewModel.swift
//  Explore
//
//  Created by Andrey Chernyshev on 15.10.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift
import RxCocoa

final class OnboardingViewModel {
    enum Step {
        case direct, paygate
    }
    
    let end = PublishRelay<Void>()
    
    lazy var step = createStep()
}

// MARK: Private
private extension OnboardingViewModel {
    func createStep() -> Driver<Step> {
        end
            .map {
                guard let config = PaygateConfigurationManagerCore().getConfiguration() else {
                    return Step.direct
                }
                
                if !config.activeSubscription && config.onboardingPaygate {
                    return Step.paygate
                }
                
                return Step.direct
            }
            .asDriver(onErrorDriveWith: .never())
    }
}
