//
//  DirectViewModel.swift
//  Explore
//
//  Created by Andrey Chernyshev on 14.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift
import RxCocoa

final class DirectViewModel {
    enum Step {
        case findPlace, map, learn, wallpapers, join, paygate
    }
    
    let didSelectElement = PublishRelay<DirectCollectionElement>()
    
    lazy var elements = createElements()
    lazy var step = createStep()
    
    private let tripManager = TripManagerCore()
}

// MARK: Private

private extension DirectViewModel {
    func createElements() -> Driver<[DirectCollectionElement]> {
        .deferred {
            let explore = DirectModel(iconName: "Direct.Explore",
                                      title: "Direct.Explore.Title".localized,
                                      subTitle: "Direct.Explore.SubTitle".localized)
            
            let learn = DirectModel(iconName: "Direct.Learn",
                                    title: "Direct.Learn.Title".localized,
                                    subTitle: "Direct.Learn.SubTitle".localized)
            
            let wallpapers = DirectModel(iconName: "Direct.Wallpapers",
                                         title: "Direct.Wallpapers.Title".localized,
                                         subTitle: "Direct.Wallpapers.SubTitle".localized)
            
            let join = DirectModel(iconName: "Direct.Join",
                                   title: "Direct.Join.Title".localized,
                                   subTitle: "Direct.Join.SubTitle".localized)
            
            let elements = [
                DirectCollectionElement.explore(explore),
                DirectCollectionElement.learn(learn),
                DirectCollectionElement.wallpapers(wallpapers),
                DirectCollectionElement.join(join),
                DirectCollectionElement.termsOfService
            ]
            
            return .just(elements)
        }
    }
    
    func createStep() -> Driver<Step> {
        didSelectElement
            .flatMap { [tripManager] element -> Single<Step> in
                switch element {
                case .explore:
                    let step: Step = tripManager.hasTrip() ? .map : .findPlace
                    return .just(step)
                case .learn:
                    guard let configuration = PaygateConfigurationManagerCore().getConfiguration() else {
                        return .just(.learn)
                    }
                    
                    if !configuration.activeSubscription && configuration.learnPaygate {
                        return .just(.paygate)
                    }
                    
                    return .just(.learn)
                case .wallpapers:
                    guard let configuration = PaygateConfigurationManagerCore().getConfiguration() else {
                        return .just(.wallpapers)
                    }
                    
                    if !configuration.activeSubscription && configuration.seePaygate {
                        return .just(.paygate)
                    }
                    
                    return .just(.wallpapers)
                case .join:
                    return .just(.join)
                case .termsOfService:
                    return .never()
                }
            }
            .asDriver(onErrorDriveWith: .empty())
    }
}
