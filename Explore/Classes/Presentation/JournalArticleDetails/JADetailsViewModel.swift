//
//  JADetailsViewModel.swift
//  Explore
//
//  Created by Andrey Chernyshev on 12.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift
import RxCocoa

final class JADetailsViewModel {
    let inputArticleId = BehaviorRelay<Int?>(value: nil)
    let inputArticle = BehaviorRelay<JournalArticle?>(value: nil)
    
    let delete = PublishRelay<Void>()
    
    private let journalManager: JournalManager = JournalManagerMock() // TODO
    
    func articleDetails() -> Driver<JournalArticleDetails?> {
        Driver
            .merge([
                initialArticle(),
                load(),
                edited()
            ])
    }
    
    func deleted() -> Driver<Bool> {
        delete
            .flatMapLatest { [weak self] in
                self?.inputId() ?? .never()
            }
            .flatMapLatest { [weak self] id -> Observable<Bool> in
                guard let this = self else {
                    return .never()
                }
                
                return this.journalManager
                    .rxDelete(articleId: id)
                    .andThen(.just(true))
                    .catchErrorJustReturn(false)
            }
            .asDriver(onErrorJustReturn: false)
    }
}

// MARK: Private
private extension JADetailsViewModel {
    func initialArticle() -> Driver<JournalArticleDetails?> {
        inputArticle
            .compactMap { $0 }
            .map(bridge(article:))
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func load() -> Driver<JournalArticleDetails?> {
        inputId()
            .flatMap { [weak self] id -> Single<JournalArticleDetails?> in
                guard let this = self else {
                    return .never()
                }
                
                return this.journalManager
                    .rxObtainArticleDetails(id: id, useCachedTags: true)
            }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func edited() -> Driver<JournalArticleDetails?> {
        JournalMediator.shared
            .rxDidCreatedArticleDetails
            .map { articleDetails -> JournalArticleDetails? in articleDetails }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func inputId() -> Observable<Int> {
        Observable
            .merge([
                inputArticleId.compactMap { $0 },
                inputArticle.compactMap { $0?.id }
            ])
    }
    
    func bridge(article: JournalArticle) -> JournalArticleDetails {
        JournalArticleDetails(id: article.id,
                              tripId: article.tripId,
                              title: article.title,
                              rating: article.rating,
                              description: article.description,
                              tags: article.tags,
                              dateTime: article.dateTime,
                              tripTime: article.tripTime,
                              originImages: article.originImages,
                              thumbsImages: article.thumbsImages,
                              sharePath: "")
    }
}
