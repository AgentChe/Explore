//
//  LearnViewModel.swift
//  Explore
//
//  Created by Andrey Chernyshev on 15.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift
import RxCocoa

final class LearnCategoriesViewModel {
    private let learnManager = LearnManagerCore()
    
    lazy var elements = createElements()
}

// MARK: Private

private extension LearnCategoriesViewModel {
    func createElements() -> Driver<[LearnCategoriesCollectionElement]> {
        let cached = Driver<[LearnCategory]>
            .deferred { [weak self] in
                return .just(self?.learnManager.getCategories() ?? [])
            }
        
        let updated = learnManager
            .rxGetCategories(forceUpdate: true)
            .asDriver(onErrorJustReturn: [])
        
        return Driver<[LearnCategory]>
            .concat([cached, updated])
            .map { categories -> [LearnCategoriesCollectionElement] in
                let list: [LearnCategoriesCollectionElement] = categories.map {
                    .category($0)
                }
                
                return [.title, .subTitle] + list
            }
    }
}
