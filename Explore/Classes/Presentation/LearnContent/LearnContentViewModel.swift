//
//  LearnContentViewModel.swift
//  Explore
//
//  Created by Andrey Chernyshev on 22.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift
import RxCocoa

final class LearnContentViewModel {
    let activityIndicator = RxActivityIndicator()
    
    private let learnManager = LearnManagerCore()
    
    func getContent(with articleId: Int) -> Driver<[LearnContentTableModel]> {
        let close = Driver<[LearnContentTableModel]>
            .deferred { .just([.title("")]) }
        
        let content = learnManager
            .rxGetContent(articleId: articleId)
            .map { content -> [LearnContentTableModel] in
                guard let content = content else {
                    return [LearnContentTableModel]()
                }
                
                return [
                    .title(content.name),
                    .image(content.imageUrl),
                    .text(content.text)
                ]
            }
            .trackActivity(activityIndicator)
            .asDriver(onErrorJustReturn: [.title("")])
        
        return Driver
            .concat([close, content])
    }
}
