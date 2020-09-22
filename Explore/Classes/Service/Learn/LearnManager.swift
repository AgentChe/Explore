//
//  LearnManager.swift
//  Explore
//
//  Created by Andrey Chernyshev on 20.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift

protocol LearnManager: class {
    // MARK: API
    func getCategories() -> [LearnCategory]
    func hasCachedCategories() -> Bool
    
    // MARK: API(Rx)
    func rxGetCategories(forceUpdate: Bool) -> Single<[LearnCategory]>
    func rxGetContent(articleId: Int) -> Single<LearnContent?>
}
