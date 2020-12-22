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
        case findPlace, map, learn, wallpapers, journal, join, paygate
    }
    
    let didSelectElement = PublishRelay<DirectCollectionElement>()
    
    lazy var sections = createSections()
    lazy var step = createStep()
    
    private let tripManager = TripManagerCore() 
}

// MARK: Private

private extension DirectViewModel {
    func createSections() -> Driver<[DirectCollectionSection]> {
        .deferred {
            var sections = [DirectCollectionSection]()
            
            let explore = DirectExploreModel(title: "Direct.Explore.Title".localized,
                                             subTitle: "Direct.Explore.SubTitle".localized)
            let s1 = DirectCollectionSection(elements: [DirectCollectionElement.explore(explore)])
            sections.append(s1)
            
            let s2 = DirectCollectionSection(elements: [.dots])
            sections.append(s2)
            
            let learn = DirectModel(iconName: "Direct.Learn",
                                    title: "Direct.Learn.Title".localized)
            
            let wallpapers = DirectModel(iconName: "Direct.Wallpapers",
                                         title: "Direct.Wallpapers.Title".localized)
            
            let join = DirectModel(iconName: "Direct.Join",
                                   title: "Direct.Join.Title".localized)
            
            let journal = DirectModel(iconName: "Direct.Journal",
                                   title: "Direct.Journal.Title".localized)
            let s3 = DirectCollectionSection(elements: [
                DirectCollectionElement.learn(learn),
                DirectCollectionElement.wallpapers(wallpapers),
                DirectCollectionElement.join(join),
                DirectCollectionElement.journal(journal)
            ])
            sections.append(s3)
            
            let s4 = DirectCollectionSection(elements: [.termsOfService])
            sections.append(s4)
            
            return .just(sections)
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
                    
                    // TODO
//                    if !configuration.activeSubscription && configuration.seePaygate {
//                        return .just(.paygate)
//                    }
                    
                    return .just(.wallpapers)
                case .journal:
                    return .just(.journal)
                case .join:
                    return .just(.join)
                case .termsOfService, .dots:
                    return .never()
                }
            }
            .asDriver(onErrorDriveWith: .empty())
    }
}
