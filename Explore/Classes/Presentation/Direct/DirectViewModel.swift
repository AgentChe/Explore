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
        case findPlace, map, learn, wallpapers
    }
    
    let didSelectElement = PublishRelay<DirectCollectionElement>()
    
    lazy var elements = createElements()
    lazy var step = createStep()
    
    private let tripManager = TripManagerMock()
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
            
            let elements = [
                DirectCollectionElement.explore(explore),
                DirectCollectionElement.learn(learn),
                DirectCollectionElement.wallpapers(wallpapers)
            ]
            
            return .just(elements)
        }
    }
    
    func createStep() -> Driver<Step> {
        didSelectElement
            .map { [tripManager] element -> Step in
                switch element {
                case .explore:
                    return tripManager.hasTrip() ? .map : .findPlace
                case .learn:
                    return .learn
                case .wallpapers:
                    return .wallpapers
                }
            }
            .asDriver(onErrorDriveWith: .empty())
    }
}
