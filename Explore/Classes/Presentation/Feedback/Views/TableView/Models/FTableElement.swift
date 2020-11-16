//
//  FTableElement.swift
//  Explore
//
//  Created by Andrey Chernyshev on 13.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxCocoa

final class FTableElement {
    let canCreateArticle = BehaviorRelay<Bool>(value: false)
    
    var tripId: Int!
    var title: String? {
        didSet {
            update()
        }
    }
    var rating: Int? {
        didSet {
            update()
        }
    }
    var description: String?
    
    var uploadedThumbsImages: [JournalImage]?
    var uploadedOriginImages: [JournalImage]?
    var uploadedThumbsImagesForDelete: [JournalImage]?
    var newImages: [UIImage]?
    
    var tags: [JournalTag] = []
    var selectedTags: [JournalTag]?
}

// MARK: Make
extension FTableElement {
    convenience init(tripId: Int,
                     title: String? = nil,
                     rating: Int? = nil,
                     description: String? = nil,
                     uploadedThumbsImages: [JournalImage]? = nil,
                     uploadedOriginImages: [JournalImage]? = nil,
                     tags: [JournalTag],
                     selectedTags: [JournalTag]? = nil) {
        self.init()
        
        self.tripId = tripId
        self.title = title
        self.rating = rating
        self.description = description
        self.uploadedThumbsImages = uploadedThumbsImages
        self.uploadedOriginImages = uploadedOriginImages
        self.tags = tags
        self.selectedTags = selectedTags
        
        update()
    }
}

// MARK: Private
private extension FTableElement {
    func update() {
        let titleEmpty = (title ?? "").isEmpty == true
        let ratingEmpty = (rating ?? -1) <= 0
        
        let nonOptionalFieldsEmpty = titleEmpty || ratingEmpty
        
        canCreateArticle.accept(!nonOptionalFieldsEmpty)
    }
}
