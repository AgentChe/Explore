//
//  SaveJournalArticleRequest.swift
//  Explore
//
//  Created by Andrey Chernyshev on 06.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import Alamofire

struct SaveJournalArticleRequest: APIRequestBody {
    private let userToken: String
    private let tripId: Int
    private let title: String
    private let rating: Int
    private let description: String?
    private let tagsIds: [Int]?
    private let originImagesIds: [Int]?
    private let thumbsImagesIds: [Int]?
    private let imagesIdsToDelete: [Int]?
    
    init(userToken: String,
         tripId: Int,
         title: String,
         rating: Int,
         description: String? = nil,
         tagsIds: [Int]? = nil,
         originImagesIds: [Int]? = nil,
         thumbsImagesIds: [Int]? = nil,
         imagesIdsToDelete: [Int]? = nil) {
        self.userToken = userToken
        self.tripId = tripId
        self.title = title
        self.rating = rating
        self.description = description
        self.tagsIds = tagsIds
        self.originImagesIds = originImagesIds
        self.thumbsImagesIds = thumbsImagesIds
        self.imagesIdsToDelete = imagesIdsToDelete
    }
    
    var url: String {
        GlobalDefinitions.domain + "/api/journal/save"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        var params: Parameters = [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "location_id": tripId,
            "title": title,
            "rating": rating,
            "anonymous_id": SDKStorage.shared.applicationAnonymousID
        ]
        
        if let description = self.description {
            params["description"] = description
        }
        
        if let tagsIds = self.tagsIds {
            params["tags"] = tagsIds
        }
        
        if let originImagesIds = self.originImagesIds {
            params["images"] = originImagesIds
        }
        
        if let thumbsImagesIds = self.thumbsImagesIds {
            params["thumbs"] = thumbsImagesIds
        }
        
        if let imagesIdsToDelete = self.imagesIdsToDelete {
            params["images_to_delete"] = imagesIdsToDelete
        }
        
        return params
    }
}
