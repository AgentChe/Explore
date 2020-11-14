//
//  FeedbackViewModel.swift
//  Explore
//
//  Created by Andrey Chernyshev on 11.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift
import RxCocoa

final class FeedbackViewModel {
    let inputTripId = BehaviorRelay<Int?>(value: nil)
    let inputArticle = BehaviorRelay<JournalArticle?>(value: nil)
    let inputArticleDetails = BehaviorRelay<JournalArticleDetails?>(value: nil)
    
    let createFeedbackInProgress = RxActivityIndicator()
    
    private let tripManager = TripManagerCore()
    private let journalManager = JournalManagerCore()
}

// MARK: API
extension FeedbackViewModel {
    func element() -> Driver<FTableElement> {
        Driver<FTableElement>
            .merge([
                inputTripId
                    .compactMap { $0 }
                    .map { tripId in FTableElement(tripId: tripId) }
                    .asDriver(onErrorDriveWith: .empty()),
                
                inputArticle
                    .compactMap { $0 }
                    .map(bridge(article:))
                    .map(map(articleDetails:))
                    .asDriver(onErrorDriveWith: .empty()),
                
                inputArticleDetails
                    .compactMap { $0 }
                    .map(map(articleDetails:))
                    .asDriver(onErrorDriveWith: .empty())
            ])
    }
    
    func createFeedback(element: FTableElement) -> Driver<Bool> {
        journalManager
            .rxCreate(tripId: element.tripId,
                      title: element.title ?? "",
                      rating: element.rating ?? 1,
                      description: element.description,
                      tagsIds: nil,
                      originImagesIds: nil,
                      thumbsImagesIds: nil,
                      imagesIdsToDelete: nil)
            .trackActivity(createFeedbackInProgress)
            .asDriver(onErrorJustReturn: nil)
            .map { $0 != nil }
    }
    
    func removeTrip() {
        tripManager.removeTripFromProgress()
        tripManager.removeTrip()
    }
}

// MARK: Private
private extension FeedbackViewModel {
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
    
    func map(articleDetails: JournalArticleDetails) -> FTableElement {
        return FTableElement(tripId: articleDetails.tripId,
                             title: articleDetails.title,
                             rating: articleDetails.rating,
                             description: articleDetails.description)
    }
}
