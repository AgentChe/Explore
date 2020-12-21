//
//  WCCollectionSection.swift
//  Explore
//
//  Created by Andrey Chernyshev on 21.12.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

enum WCCollectionSection {
    struct Section {
        let title: String
        let elements: [WCCollectionElement]
    }
    
    case newArrivals(Section)
    case categories(Section)
}
