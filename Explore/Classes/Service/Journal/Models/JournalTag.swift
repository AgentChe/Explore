//
//  JournalTag.swift
//  Explore
//
//  Created by Andrey Chernyshev on 06.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

struct JournalTag {
    let id: Int
    let name: String
}

// MARK: Codable
extension JournalTag: Codable {}
