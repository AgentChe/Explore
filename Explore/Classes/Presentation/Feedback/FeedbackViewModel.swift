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
    
    private let tripManager = TripManagerMock() // TODO
    private let journalManager = JournalManagerMock() // TODO
    private let imageManager = ImageManagerMock() // TODO
}

// MARK: API
extension FeedbackViewModel {
    func element() -> Driver<FTableElement> {
        let element = Driver<FTableElement>
            .merge([
                inputTripId
                    .compactMap { $0 }
                    .map { tripId in FTableElement(tripId: tripId, tags: []) }
                    .asDriver(onErrorDriveWith: .empty()),
                
                inputArticle
                    .compactMap { $0 }
                    .map(bridge(article:))
                    .map(map(articleDetails:))
                    .asDriver(onErrorDriveWith: .empty()),
                
                inputArticleDetails
                    .compactMap { $0 }
                    .map(map(articleDetails:))
                    .asDriver(onErrorDriveWith: .empty()),
                
                JournalMediator.shared
                    .rxDidCreatedArticleDetails
                    .map(map(articleDetails:))
                    .asDriver(onErrorDriveWith: .empty())
            ])
        
        let tags = loadTags()
        
        return Driver
            .combineLatest(element, tags)
            .map { element, tags -> FTableElement in
                element.tags = tags
                return element
            }
    }
    
    func createFeedback(element: FTableElement) -> Driver<Bool> {
        uploadImages(element: element)
            .flatMap { [weak self] uploadedPictures -> Single<JournalArticleDetails?> in
                guard let this = self else {
                    return .never()
                }
                
                let storedOriginImagesIds = element.uploadedOriginImages.map { $0.map { $0.id } } ?? []
                let uploadedOriginImagesIds = uploadedPictures.map { $0.origin.id }
                
                let storedThumbsImagesIds = element.uploadedThumbsImages.map { $0.map { $0.id } } ?? []
                let uploadedThumbsImagesIds = uploadedPictures.map { $0.thumb.id }
                
                return this.journalManager
                    .rxCreate(tripId: element.tripId,
                              title: element.title ?? "",
                              rating: element.rating ?? 1,
                              description: element.description,
                              tagsIds: element.selectedTags?.compactMap { $0.id },
                              originImagesIds: storedOriginImagesIds + uploadedOriginImagesIds,
                              thumbsImagesIds: storedThumbsImagesIds + uploadedThumbsImagesIds,
                              imagesIdsToDelete: element.uploadedThumbsImagesForDelete.map { $0.map { $0.id } })
            }
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
    func loadTags() -> Driver<[JournalTag]> {
        journalManager
            .rxRetrieveTags(forceUpdate: true)
            .asDriver(onErrorJustReturn: [])
    }
    
    func uploadImages(element: FTableElement) -> Single<[Picture]> {
        Observable
            .from(element.newImages ?? [])
            .flatMap { [weak self] image -> Single<Picture?> in
                guard let this = self else {
                    return .never()
                }
                
                return this.imageManager
                    .upload(image: image)
                    .catchErrorJustReturn(nil)
            }
            .toArray()
            .map { $0.compactMap { $0 } }
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
    
    func map(articleDetails: JournalArticleDetails) -> FTableElement {
        return FTableElement(tripId: articleDetails.tripId,
                             title: articleDetails.title,
                             rating: articleDetails.rating,
                             description: articleDetails.description,
                             uploadedThumbsImages: articleDetails.thumbsImages,
                             uploadedOriginImages: articleDetails.originImages,
                             tags: [],
                             selectedTags: articleDetails.tags)
    }
}
