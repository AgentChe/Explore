//
//  JournalManager.swift
//  Explore
//
//  Created by Andrey Chernyshev on 10.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift
import RxCocoa

protocol JournalManager: class {
    // MARK: API(Rx)
    func rxRetrieveArticles(forceUpdate: Bool) -> Single<[JournalArticle]>
    func rxRetrieveTags(forceUpdate: Bool) -> Single<[JournalTag]>
    func rxObtainArticleDetails(id: Int, useCachedTags: Bool) -> Single<JournalArticleDetails?>
    func rxCreate(tripId: Int,
                  title: String,
                  rating: Int,
                  description: String?,
                  tagsIds: [Int]?,
                  originImagesIds: [Int]?,
                  thumbsImagesIds: [Int]?,
                  imagesIdsToDelete: [Int]?) -> Single<JournalArticleDetails?>
    func rxDelete(articleId: Int) -> Completable
}
