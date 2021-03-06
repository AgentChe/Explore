//
//  JournalImage.swift
//  Explore
//
//  Created by Andrey Chernyshev on 06.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

struct JournalImage {
    let id: Int
    let url: String
}

// MARK: Codable
extension JournalImage: Codable {}
