//
//  Image.swift
//  Explore
//
//  Created by Andrey Chernyshev on 10.11.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

struct Image {
    let id: Int
    let url: String
}

// MARK: Codable
extension Image: Codable {}
